FROM registry.cloudclusters.io/cloudclusters/lnmp:test-v1.1.2

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

COPY docker-entrypoint.sh  install_wordpress.sh wp /usr/bin/
COPY supervisord.conf /etc/supervisor/supervisord.conf
RUN ln -sf usr/bin/docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306 80 8080
CMD ["-c","/etc/supervisor/supervisord.conf"]
