FROM registry.cloudclusters.net/cloudclusters/opencart-lamp-php7.1:online-v0.0.1

#install drupal
RUN apt-get update ; \
     apt-get install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/* ; \
     cd /tmp && wget https://github.com/opencart/opencart/releases/download/3.0.3.2/opencart-3.0.3.2.zip && unzip opencart-3.0.3.2.zip ; \
     a2enmod rewrite ; \
     a2enmod proxy_fcgi

RUN mkdir /tmp/vqmod && cd /tmp/vqmod && wget https://github.com/vqmod/vqmod/releases/download/v2.6.4-opencart/vqmod-2.6.4-opencart.zip && unzip vqmod-2.6.4-opencart.zip

COPY docker-entrypoint.sh install_opencart.sh readinessProbe.sh livenessProbe.sh filebrowser /usr/bin/
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY cli_install.php /tmp/upload/install
RUN ln -sf usr/bin/docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306 80 8080

CMD ["-c","/etc/supervisor/supervisord.conf"]
