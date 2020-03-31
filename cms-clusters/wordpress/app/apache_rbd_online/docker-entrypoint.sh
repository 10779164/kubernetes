#!/bin/bash
set -Eeuo pipefail

if [ ! -d /data/wordpress/ ]; then
        mkdir /data/wordpress
fi
ln -sf /data/wordpress/ /var/www/html
ln -sf /configfile/mysql.cnf /etc/mysql/conf.d/mysql.cnf
ln -sf /configfile/php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf

if [ ! -f /data/wordpress/wp-config.php ]; then
	cp  /configfile/wp-config.php /var/www/html/wp-config.php
	chown www-data:www-data /var/www/html/wp-config.php
fi

ln -sf /configfile/000-default.conf /etc/apache2/sites-enabled/000-default.conf 
#ln -sf /configfile/supervisord.conf /etc/supervisor/supervisord.conf
if [ ! -f /var/www/html/index.php ]; then
    mv /tmp/wordpress/* /var/www/html/
    rm -rf /tmp/*
    chown -R www-data:www-data /var/www/html/
    chmod -R 777 /var/www/html/
    #cp -a /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
fi

if [ -d /data/mysql ]; then
    chown -R mysql:mysql /data/mysql 
fi

export FB_DATABASE_DIR=/opt/filebrowser
if [ ! -d ${FB_DATABASE_DIR} ];then
	mkdir ${FB_DATABASE_DIR}
	chown www-data:www-data ${FB_DATABASE_DIR} -R
fi

export FB_DATABASE=${FB_DATABASE_DIR}/filebrowser.db
if [ ! -f ${FB_DATABASE} ]; then
	gosu www-data filebrowser -d ${FB_DATABASE} config init
	gosu www-data filebrowser -d ${FB_DATABASE} config set --address 0.0.0.0
	gosu www-data filebrowser -d ${FB_DATABASE} config set --port 8000
	gosu www-data filebrowser -d ${FB_DATABASE} config set --root /data/wordpress
	gosu www-data filebrowser -d ${FB_DATABASE} config set --baseurl /filebrowser 
	gosu www-data filebrowser -d ${FB_DATABASE} config set --shell "bash -c"
	gosu www-data filebrowser -d ${FB_DATABASE} users add ${FB_USERNAME} ${FB_PASSWORD} --perm.admin
	gosu www-data filebrowser -d ${FB_DATABASE} users update ${FB_USERNAME} --commands ls,cd,pwd,tar,git,wp,cat,unzip,supervisorctl,mysql,cp,mv
fi

set -- supervisord "$@"
exec "$@"
