#!/bin/bash
if [ ! -f /var/www/html/.installed_opencart ]; then
    #check opencart status
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

    #initialization opencart
    DOMAIN=$(hostname -f|cut -f 5-6 -d '.')
    gosu www-data cp /data/opencart/html/system/storage /data/opencart/storage -R
    cd /var/www/html/install && gosu www-data php cli_install.php install --db_hostname 127.0.0.1 --db_username ${MYSQL_USER} --db_password ${MYSQL_PASSWORD} \
    --db_database ${MYSQL_DATABASE} --db_driver mysqli --db_port 3306 --username ${OPENCART_USER} --password ${OPENCART_PASSWORD} --storage_dir /data/opencart/ --email ${OPENCART_EMAIL} \
    --http_server https://${POD_NAMESPACE}-0.${DOMAIN}/

    if [ $? -eq 0 ] ;then
    curl http://127.0.0.1/vqmod/install/
    touch /var/www/html/.installed_opencart 
    rm /var/www/html/install -fr
    fi

fi
