FROM ubuntu:16.04

RUN apt-get update ; \
    apt-get install -y supervisor nginx git npm wget curl vim  && rm -rf /var/lib/apt/lists/* ; \
#    sed -i '656c post_max_size = 512M' /etc/php/7.0/fpm/php.ini ; \
#    sed -i '809c upload_max_filesize = 512M' /etc/php/7.0/fpm/php.ini ; \
#    sed -i '23c user = root' /etc/php/7.0/fpm/pool.d/www.conf ; \
#    sed -i '24c group = root' /etc/php/7.0/fpm/pool.d/www.conf ; \
    mkdir /home/administrator/v2cloudclusters/

#RUN echo mysql-server-5.7 mysql-server/root_password password root@pass | debconf-set-selections \ 
#        && echo mysql-server-5.7 mysql-server/root_password_again password root@pass | debconf-set-selections \
#        && apt-get update && apt-get install -y mysql-server-5.7 && rm -rf /var/lib/apt/lists/* \
#        && rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
#        && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
#        && chmod 777 /var/run/mysqld \
#        && find /etc/mysql/ -name '*.cnf' -print0 \
#                | xargs -0 grep -lZE '^(bind-address|log)' \
#                | xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/' \
#        && echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf

ENV WORDPRESS_VERSION 5.1
RUN cd /home/administrator/v2cloudclusters && \
    git clone http://Bruce:Bruceli426@gitlab.cloudclusters.net/cloudclusters-websites/cloudclusters.git && \
    cd cloudclusters && \
    git checkout dev-refactor && \
    git pull && \
    npm install && \
    npm run generate:p  && \
#    tar -xzf wordpress*.tar.gz && \
#    rm -rf /var/www/*
#    mv wordpress/* /var/www/html/ && \
#    rm -rf /tmp/* && \
#    chown -R www-data:www-data /var/www/html && \
#    chmod -R 755 /var/www/html && \
#    cp -a /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

COPY docker-entrypoint.sh mysql_startup.sh install_wordpress.sh wp /usr/bin/
RUN ln -s usr/bin/docker-entrypoint.sh /entrypoint.sh ; \
    rm /etc/nginx/sites-enabled/default 
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE  80 443 8080
CMD ["-c","/etc/supervisor/supervisord.conf"]
