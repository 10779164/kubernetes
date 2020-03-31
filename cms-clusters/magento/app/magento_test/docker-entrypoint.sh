#!/bin/bash
export PATH=$PATH:/var/www/html/bin
if [ ! -d /data/magento/ ]; then
    mkdir /data/magento
fi

ln -sf /data/magento/ /var/www/html
ln -sf /configfile/mysql.cnf /etc/mysql/conf.d/mysql.cnf
ln -sf /configfile/000-default.conf /etc/apache2/sites-enabled/000-default.conf
#ln -sf /configfile/supervisord.conf /etc/supervisor/supervisord.conf
if [ ! -f /var/www/html/index.php ]; then
    mv /tmp/magento*/* /tmp/magento*/.[^.]* /var/www/html/
    mv /composer.json /data/magento
    rm -rf /tmp/*
    chown -R www-data:www-data /var/www/html/
    chmod -R 766 /var/www/html/
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
	gosu www-data filebrowser -d ${FB_DATABASE} config set --root /data/magento
	gosu www-data filebrowser -d ${FB_DATABASE} config set --baseurl /filebrowser 
	gosu www-data filebrowser -d ${FB_DATABASE} config set --shell "bash -c"
	gosu www-data filebrowser -d ${FB_DATABASE} users add ${FB_USERNAME} ${FB_PASSWORD} --perm.admin
	gosu www-data filebrowser -d ${FB_DATABASE} users update ${FB_USERNAME} --commands ls,cd,pwd,tar,git,magento,cat,unzip,supervisorctl,mysql,cp,mv,php
fi

set -- supervisord "$@"
exec "$@"
