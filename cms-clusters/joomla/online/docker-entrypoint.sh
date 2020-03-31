#!/bin/bash
set -Eeuo pipefail

export PATH=$PATH:/var/www/html/vendor/bin

if [ ! -d /data/joomla/ ]; then
	mkdir /data/joomla
fi

ln -sf /data/joomla/ /var/www/html
ln -sf /configfile/mysql.cnf /etc/mysql/conf.d/mysql.cnf
ln -sf /configfile/php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf
#ln -sf /configfile/wp-config.php /var/www/html/wp-config.php
ln -sf /configfile/000-default.conf /etc/apache2/sites-enabled/000-default.conf
ln -sf /configfile/supervisord.conf /etc/supervisor/supervisord.conf
if [ ! -f /data/joomla/index.php ]; then
	cd /data/joomla/ ; \
	tar --create \
		    --file - \
		        --one-file-system \
			    --directory /tmp/joomla \
			        --owner www-data --group www-data \
				    . | tar --extract --file -
    #mv /tmp/joomla*/* /tmp/joomla*/.[^.]* /data/joomla/
    rm -rf /tmp/*
    #chown -R www-data:www-data /data/joomla/
    chmod -R 776 /data/joomla/
    #cp -a /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
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
        gosu www-data filebrowser -d ${FB_DATABASE} config set --root /data/joomla
        gosu www-data filebrowser -d ${FB_DATABASE} config set --baseurl /filebrowser 
        gosu www-data filebrowser -d ${FB_DATABASE} config set --shell "bash -c"
        gosu www-data filebrowser -d ${FB_DATABASE} users add ${FB_USERNAME} ${FB_PASSWORD} --perm.admin
        gosu www-data filebrowser -d ${FB_DATABASE} users update ${FB_USERNAME} --commands ls,cd,pwd,tar,git,joomla,cat,unzip,supervisorctl,mysql,cp,mv
fi


set -- supervisord "$@"
exec "$@"
