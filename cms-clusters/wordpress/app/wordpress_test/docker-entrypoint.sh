#!/bin/bash
if [ ! -d /data/wordpress/ ]; then
	mkdir /data/wordpress
	ln -sf /data/wordpress/ /var/www/html
	ln -sf /configfile/mysql.cnf /etc/mysql/conf.d/mysql.cnf
	ln -sf /configfile/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf
	#ln -sf /configfile/wp-config.php /var/www/html/wp-config.php
	ln -sf /configfile/nginx.conf /etc/nginx/nginx.conf
	#ln -sf /configfile/supervisord.conf /etc/supervisor/supervisord.conf
	if [ ! -f /var/www/html/index.php ]; then
	    mv /tmp/wordpress/* /var/www/html/
	    rm -rf /tmp/*
	    chown -R www-data:www-data /var/www/html/
	    chmod -R 776 /var/www/html/
	    #cp -a /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
	fi
fi

set -- supervisord "$@"
exec "$@"
