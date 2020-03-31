#########################################################################
# File Name: livenessProbe.sh
# Author: Sean
# mail: sean.x.dbm@gmail.com
# Created Time: 2019年06月12日 星期三 16时15分12秒
# Revision:
# Description:
# Note:
#########################################################################
#!/bin/bash
#process check
#supervisord.pid check
if [ -f /var/run/supervisord.pid ]; then
    supervisor_code=0
else
    supervisor_code=1
fi

#mysqld.pid check
if [ -f /var/run/mysqld/mysqld.pid ]; then
    mysqld_code=0
else
    mysqld_code=1
fi

if [ -f /var/run/apache2/apache2.pid ]; then
    apache2_code=0
else
    apache2_code=1
fi

if [ -f /var/run/php/php7.3-fpm.pid ]; then
    php_code=0
else
    php_code=1
fi

if [ ${supervisor_code} -a ${mysqld_code} -a ${apache2_code} -a ${php_code} == 0 ]; then
    exit 0
else
    exit 1
fi
