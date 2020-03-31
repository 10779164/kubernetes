FROM registry.cloudclusters.net/cloudclusters/nginx:v0.1

RUN rm -rf /var/www/html && \
    rm /etc/nginx/sites-enabled/default && \
    rm /etc/supervisor/supervisord.conf && \
    mkdir /configuration -p && \
    mkdir /data/portal -p

COPY portal.conf  /configuration/

RUN cd /data/portal && \
    git clone http://Bruce:Bruceli426902@gitlab.cloudclusters.net/cloudclusters-websites/cloudclusters.git && \
    cd cloudclusters && \
    git checkout dev-refactor && \
    npm install && \
    npm run generate:p

COPY docker-entrypoint.sh   /usr/bin/
COPY supervisord.conf /etc/supervisor/supervisord.conf
RUN ln -sf /usr/bin/docker-entrypoint.sh /entrypoint.sh && \
    ln -s /configuration/portal.conf /etc/nginx/sites-enabled/portal.conf
 

ENTRYPOINT ["docker-entrypoint.sh"]


EXPOSE  80 8080
CMD ["-c","/etc/supervisor/supervisord.conf"]
