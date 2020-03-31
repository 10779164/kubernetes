#########################################################################
# File Name: readinessProbe.sh
# Author: Sean
# mail: sean.x.dbm@gmail.com
# Created Time: 2019年06月12日 星期三 16时15分25秒
# Revision:
# Description:
# Note:
#########################################################################
#!/bin/bash
#mysql check
mysqladmin ping -u root -p${MYSQL_ROOT_PASSWORD}
mysql_code=$?

#web check
curl -I -m 10 -o /dev/null -s -w %{http_code}  http://127.0.0.1/

#/var/www/html/.installed_drupal exist check
if [ -f /var/www/html/.installed_magento ]; then
    init_code=0
else
    init_code=1
fi

if [ ${mysql_code} -a ${init_code} == 0 ]; then
    exit 0
else
    exit 1
fi
