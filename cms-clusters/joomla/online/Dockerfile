FROM registry.cloudclusters.net/cloudclusters/lamp-php7.3:online-v0.0.3


#install composer
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#RUN gosu www-data composer create-project drupal-composer/drupal-project:8.x-dev /var/www/my_drupal --stability dev --no-interaction
#https://ftp.drupal.org/files/projects/drupal-8.6.15.tar.gz
ENV JOOMLA_VERSION 3-9-13
#ENV JOOMLA_MD5 478775da7793029b55c9b66ad7a423fd

RUN mkdir /tmp/joomla && cd /tmp/joomla \ 
        && apt update && apt install zip unzip -y \
        && rm -rf /var/www/html 
#        && curl -fSL "https://downloads.joomla.org/cms/joomla3/${JOOMLA_VERSION}/Joomla_${JOOMLA_VERSION}-Stable-Full_Package.tar.gz?format=gz" -o joomla.tar.gz \
#	&& echo "${JOOMLA_MD5} *joomla.tar.gz" | md5sum -c - \
#        && wget  https://drupal-5572-0.cloudclusters.net/joomla-all.zip --no-check-certificate \
#	&& tar -xz --strip-components=1 -f joomla.tar.gz \
#        && unzip joomla-all.zip \
#	&& rm joomla.tar.gz \
#        && rm -rf /var/www/html \
#        && ls -l \
#	&& chown -R www-data:www-data /tmp/joomla

#RUN cd /tmp && \
#    wget "https://ftp.drupal.org/files/projects/drupal-8.6.15.tar.gz" && \
#    tar -xzf drupal*.tar.gz && \
#    rm -rf /var/www/html && \ 
##    mv drupal-8.6.15/* /var/www/html &&\
##    rm -rf /tmp/* && \
#    rm -rf /etc/apache2/sites-enabled/000-default.conf && \
#    chown -R www-data:www-data /tmp/drupal-8.6.15/ && \
#    chmod -R 755  /tmp/drupal-8.6.15/ 
COPY joomla-all.zip /tmp/
#RUN  sed -ex ; \
RUN  cd  /tmp/ ; \
     unzip joomla-all.zip -d /tmp/joomla
COPY docker-entrypoint.sh  install_joomla.sh readinessProbe.sh livenessProbe.sh restore-database.sh filebrowser /usr/bin/
RUN  cd  /usr/bin/ ; \
     ln -sf usr/bin/docker-entrypoint.sh /entrypoint.sh ; \
     chmod +x /usr/bin/restore-database.sh
COPY supervisord.conf /etc/supervisor/supervisord.conf
#RUN  sed -ex ; \
#        cd  /tmp/joomla/ ; \
#        unzip joomla-all.zip ; \
#        chmod +x /usr/bin/restore-database.sh ; \
#        cd  /usr/bin/ ; \
#        ln -sf usr/bin/docker-entrypoint.sh /entrypoint.sh
#       && rm joomla.tar.gz \
#        && rm -rf /var/www/html \
#        && ls -l \
#        && gosu www-data chown -R www-data:www-data /tmp/joomla

#   gosu www-data composer global require joomlatools/console

#COPY docker-entrypoint.sh  install_joomla.sh readinessProbe.sh livenessProbe.sh restore-database.sh filebrowser /usr/bin/
#RUN gosu www-data chmod +x /usr/bin/restore-database.sh
#COPY supervisord.conf /etc/supervisor/supervisord.conf
#RUN ln -sf usr/bin/docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306 80 8080
CMD ["-c","/etc/supervisor/supervisord.conf"]
