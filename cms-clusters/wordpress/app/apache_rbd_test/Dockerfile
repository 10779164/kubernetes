FROM ubuntu:16.04

RUN apt-get update ; \
    apt-get install -y supervisor apache2 libapache2-mod-php php-fpm php-mysql php-gd php-dom php-xml php-zip php-cli php-opcache php-curl php-json php-mbstring wget curl vim  && rm -rf /var/lib/apt/lists/* ; \
    sed -i '656c post_max_size = 512M' /etc/php/7.0/*/php.ini ; \
    sed -i '809c upload_max_filesize = 512M' /etc/php/7.0/*/php.ini ; \
    a2enmod rewrite ; \
    mkdir /run/php/

RUN echo mysql-server-5.7 mysql-server/root_password password root@pass | debconf-set-selections \ 
        && echo mysql-server-5.7 mysql-server/root_password_again password root@pass | debconf-set-selections \
        && apt-get update && apt-get install -y mysql-server-5.7 && rm -rf /var/lib/apt/lists/* \
        && rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
        && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
        && chmod 766 /var/run/mysqld \
#        && find /etc/mysql/ -name '*.cnf' -print0 \
#                | xargs -0 grep -lZE '^(bind-address|log)' \
#                | xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/' \
        && echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf

ENV WORDPRESS_VERSION 5.1
RUN cd /tmp && \
    wget "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz" && \
    tar -xzf wordpress*.tar.gz && \
    rm -rf /var/www/*
#    mv wordpress/* /var/www/html/ && \
#    rm -rf /tmp/* && \
#    chown -R www-data:www-data /var/www/html && \
#    chmod -R 755 /var/www/html && \
#    cp -a /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

COPY docker-entrypoint.sh mysql_startup.sh install_wordpress.sh wp /usr/bin/
COPY supervisord.conf /etc/supervisor/supervisord.conf
RUN ln -s usr/bin/docker-entrypoint.sh /entrypoint.sh
#    rm /etc/nginx/sites-enabled/default 
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306 80 8080
CMD ["-c","/etc/supervisor/supervisord.conf"]
