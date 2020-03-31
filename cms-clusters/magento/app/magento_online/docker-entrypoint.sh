#!/bin/bash
set -Eeuo pipefail

if [ ! -d /data/magento/ ]; then
    mkdir /data/magento
    rm /var/www/* -fr
fi

ln -sf /data/magento/ /var/www/html
ln -sf /configfile/mysql.cnf /etc/mysql/conf.d/mysql.cnf
ln -sf /configfile/000-default.conf /etc/apache2/sites-enabled/000-default.conf
#ln -sf /configfile/supervisord.conf /etc/supervisor/supervisord.conf
if [ ! -f /var/www/html/index.php ]; then
    mv /tmp/magento*/* /tmp/magento*/.[^.]* /var/www/html/
    rm -rf /tmp/*
    chown -R www-data:www-data /var/www/html/
    chmod -R 766 /var/www/html/
fi

set -- supervisord "$@"
exec "$@"
