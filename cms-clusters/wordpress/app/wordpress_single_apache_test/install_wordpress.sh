#!/bin/bash
if [ ! -f /var/www/html/.installed_wordpress ]; then
    HTTP_CODE=0
    until printf '.'  && [[  ${HTTP_CODE} -lt 500 && ${HTTP_CODE} -ge 200 ]]; do
        HTTP_CODE=`curl -I -m 10 -o /dev/null -s -w %{http_code}  http://127.0.0.1/`
        sleep 1
    done
    MYSQL_STATUS="mysqld"
    until printf '.'  && [[  ${MYSQL_STATUS} == "mysqld is alive" ]]; do
	MYSQL_STATUS=`mysqladmin ping -u root -p${MYSQL_ROOT_PASSWORD}`
        sleep 1
    done
    HOSTNAME=`hostname -f`
    DOMAIN=$(hostname -f|cut -f 5-6 -d '.')
    wp core install --url="https://${POD_NAMESPACE}-0.${DOMAIN}" --title="${WP_TITLE}" --admin_user="${WP_USER}" --admin_password="${WP_PASSWORD}" --admin_email="${WP_EMAIL}" --allow-root --path=/var/www/html/
    wp theme activate twentyseventeen --allow-root --path=/var/www/html/
    #wp core install --url="http://${HOSTNAME}" --title='Blog Title' --admin_user="${WP_USER}" --admin_password="${WP_PASSWORD}" --admin_email='email@domain.com' --allow-root --path=/var/www/html/
    touch /var/www/html/.installed_wordpress
fi
