FROM registry.cloudclusters.net/cloudclusters/magento-lamp:test-v0.0.8 

#install drupal
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY auth.json /root/.composer/auth.json
RUN a2enmod rewrite;\
    mkdir /tmp/magento ; \
    composer create-project --no-dev --repository=https://repo.magento.com/ magento/project-community-edition /tmp/magento

RUN apt-get update ; \
    apt-get install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/* 

COPY docker-entrypoint.sh install_magento.sh readinessProbe.sh livenessProbe.sh filebrowser /usr/bin/
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY composer.json /composer.json
RUN ln -sf usr/bin/docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306 80 8080
CMD ["-c","/etc/supervisor/supervisord.conf"]
