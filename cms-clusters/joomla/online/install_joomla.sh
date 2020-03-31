#!/bin/bash
function log() {
	local msg="$1"
	local timestamp
	timestamp=$(date --iso-8601=ns)
	echo "[$timestamp] [$script_name] $msg" >> /data/joomla/log.txt
}
if [ ! -f /var/www/html/.installed_joomla ]; then
    #check joomla status
#    HTTP_CODE=0
#    until printf '.'  && [[  ${HTTP_CODE} -lt 500 && ${HTTP_CODE} -ge 200 ]]; do
#        HTTP_CODE=`curl -I -m 10 -o /dev/null -s -w %{http_code}  http://127.0.0.1/`
#        sleep 1
#    done

   log "check mysql status"
    MYSQL_STATUS="mysqld"
    until printf '.'  && [[  ${MYSQL_STATUS} == "mysqld is alive" ]]; do
	MYSQL_STATUS=`mysqladmin ping -u root -p${MYSQL_ROOT_PASSWORD}`
        sleep 1
    done

    log "initialization joomla"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < /data/joomla/joomla.sql
    mysql -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} -D joomla -e "update jm_users set password = MD5('${JM_PASSWORD}') where jm_users.username = 'admin';"

    touch /var/www/html/.installed_joomla
fi
