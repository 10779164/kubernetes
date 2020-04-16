#firstlaunch=${DATA_FOLDER}/.firstlaunch

if [ ! -d ${PGDATA} ]; then
    mkdir -p ${PGDATA}
    chown -R postgres:postgres ${PGDATA}
    su postgres -c '/usr/lib/postgresql/9.5/bin/pg_ctl initdb -U postgres'
    #su postgres -c 'psql -U postgres -d postgres -c "CREATE DATABASE thingsboard"'
fi

if [ ! -d /var/log/postgres ]; then
    mkdir /var/log/postgres
    chown -R postgres:postgres /var/log/postgres
fi

su postgres -c '/usr/lib/postgresql/9.5/bin/pg_ctl -l /var/log/postgres/postgres.log -w start'

if [ ! -f ${firstlaunch} ]; then
    su postgres -c 'psql -U postgres -d postgres -c "CREATE DATABASE thingsboard"'
fi

