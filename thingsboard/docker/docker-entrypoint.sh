#!/bin/bash
set -eo pipefail

#postgresql
if [ ! -d ${postgres_data} ]; then
	mkdir -p ${postgres_data}
    	chown -R postgres:postgres ${postgres_data}
    	su postgres -c '/usr/lib/postgresql/9.5/bin/pg_ctl initdb -U postgres -D ${postgres_data}'
fi

if [ ! -d /var/log/postgres ]; then
    	mkdir /var/log/postgres
    	chown -R postgres:postgres /var/log/postgres
fi

su postgres -c '/usr/lib/postgresql/9.5/bin/pg_ctl -D ${postgres_data} -l /var/log/postgres/postgres.log -w start'

if [ "$( psql -U postgres -tAc "SELECT 1 FROM pg_database WHERE datname='thingsboard'" )" != '1' ]; then
	su postgres -c 'psql -U postgres -d postgres -c "CREATE DATABASE thingsboard"'
	psql -U postgres -tAc " ALTER USER postgres WITH PASSWORD '${postgres_db_passwd}';"
fi


#thingsboard
if [ ! -d /usr/share/thingsboard ]; then
	dpkg -i thingsboard-2.4.3.deb
	sed -i '$a\export DATABASE_ENTITIES_TYPE=sql' /usr/share/thingsboard/conf/thingsboard.conf
	sed -i '$a\export DATABASE_TS_TYPE=sql' /usr/share/thingsboard/conf/thingsboard.conf
	sed -i '$a\export SPRING_JPA_DATABASE_PLATFORM=org.hibernate.dialect.PostgreSQLDialect' /usr/share/thingsboard/conf/thingsboard.conf
	sed -i '$a\export SPRING_DRIVER_CLASS_NAME=org.postgresql.Driver' /usr/share/thingsboard/conf/thingsboard.conf
	sed -i '$a\export SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/thingsboard' /usr/share/thingsboard/conf/thingsboard.conf
	sed -i '$a\export SPRING_DATASOURCE_USERNAME=postgres' /usr/share/thingsboard/conf/thingsboard.conf
	sed -i '$a\export SPRING_DATASOURCE_PASSWORD='${thingsboard_db_password}'' /usr/share/thingsboard/conf/thingsboard.conf
	sed -i '$a\export JAVA_OPTS="$JAVA_OPTS -Xms256M -Xmx256M"' /usr/share/thingsboard/conf/thingsboard.conf
	/usr/share/thingsboard/bin/install/install.sh --loadDemo
fi


#
set -- supervisord "$@"
exec "$@"


