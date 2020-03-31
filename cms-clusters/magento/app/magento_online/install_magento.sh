#!/bin/bash
if [ ! -f /var/www/html/.installed_magento ]; then
    #check drupal status
    HTTP_CODE=0
    until printf '.'  && [[  ${HTTP_CODE} -lt 500 && ${HTTP_CODE} -ge 200 ]]; do
        HTTP_CODE=`curl -I -m 10 -o /dev/null -s -w %{http_code}  http://127.0.0.1/`
        sleep 1
    done

    #check mysql status
    MYSQL_STATUS="mysqld"
    until printf '.'  && [[  ${MYSQL_STATUS} == "mysqld is alive" ]]; do
	MYSQL_STATUS=`mysqladmin ping -u root -p${MYSQL_ROOT_PASSWORD}`
        sleep 1
    done

    #initialization drupal
    DOMAIN=$(hostname -f|cut -f 5-6 -d '.')
    gosu www-data /var/www/html/bin/magento setup:install \
--base-url=https://${POD_NAMESPACE}-0.${DOMAIN} \
--db-host=localhost \
--db-name=${MYSQL_DATABASE} \
--db-user=${MYSQL_USER} \
--db-password=${MYSQL_PASSWORD} \
--backend-frontname=admin \
--admin-firstname=admin \
--admin-lastname=admin \
--admin-email=${MAGENTO_EMAIL} \
--admin-user=${MAGENTO_USER} \
--admin-password=${MAGENTO_PASSWORD} \
--language=en_US \
--currency=USD \
--timezone=America/Chicago \
--use-rewrites=1

    cron
    gosu www-data /var/www/html/bin/magento cron:install

    touch /var/www/html/.installed_magento 
fi
