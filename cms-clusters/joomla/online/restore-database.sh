#! /bin/bash

BPATH=/data/joomla/
ROOTPASS=$MYSQL_ROOT_PASSWORD
ROOTUSER="root"
MYSQL_DATABASE="joomla"
HOST="127.0.0.1"
mysql -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < /var/www/html/joomla.sql

#mysql -u root -h $HOST -P $ROOTPASS < /var/www/html/joomla.sql
