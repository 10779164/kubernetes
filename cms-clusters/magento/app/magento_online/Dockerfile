FROM registry.cloudclusters.net/cloudclusters/magento-lamp:test-v0.0.6 

#install drupal
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#ENV DRUPAL_VERSION 8.7.3
#ENV DRUPAL_MD5 bba896a1ed2fbe4a1744d82c036fcfc4 

#RUN mkdir /tmp/drupal && cd /tmp/drupal \ 
#        && curl -fSL "https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
#	&& echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
#	&& tar -xz --strip-components=1 -f drupal.tar.gz \
#	&& rm drupal.tar.gz \
#        && rm -rf /var/www/html \
#        && ls -l \
#	&& chown -R www-data:www-data /tmp/drupal

#RUN cd /tmp && \
#    wget "https://ftp.drupal.org/files/projects/drupal-8.6.15.tar.gz" && \
#    tar -xzf drupal*.tar.gz && \
#    rm -rf /var/www/html && \ 
#    mv drupal-8.6.15/* /var/www/html &&\
#    rm -rf /tmp/* && \
#    rm -rf /etc/apache2/sites-enabled/000-default.conf && \
#    chown -R www-data:www-data /tmp/drupal-8.6.15/ && \
#    chmod -R 755  /tmp/drupal-8.6.15/ 

COPY auth.json /root/.composer/auth.json
RUN a2enmod rewrite;\
    mkdir /tmp/magento ; \
    composer create-project --repository=https://repo.magento.com/ magento/project-community-edition /tmp/magento

COPY docker-entrypoint.sh install_magento.sh readinessProbe.sh livenessProbe.sh /usr/bin/
COPY supervisord.conf /etc/supervisor/supervisord.conf
RUN ln -sf usr/bin/docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306 80 8080
CMD ["-c","/etc/supervisor/supervisord.conf"]
