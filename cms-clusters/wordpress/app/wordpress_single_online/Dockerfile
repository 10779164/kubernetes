FROM ubuntu:latest

RUN apt-get update ; \
    apt-get install -y supervisor nginx npm git curl vim  && rm -rf /var/lib/apt/lists/* 

WORKDIR /etc/www/html
RUN cd /etc/www/html/ && \
    git clone http://Bruce:Bruceli426@gitlab.cloudclusters.net/cloudclusters-websites/cloudclusters.git && \
    cd cloudclusters && \
    git checkout dev-refactor 
WORKDIR /etc/www/html/cloudclusters/
RUN    git pull && \
    npm install && \
    npm run generate:p 
COPY occlusters.com.conf /etc/nginx/sites-enabled/
RUN ln -s usr/bin/docker-entrypoint.sh /entrypoint.sh ; \
    rm /etc/nginx/sites-enabled/default ; \
    mkdir -p /home/administrator/v2cloudclusters/ 
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE  80 8080
CMD ["-c","/etc/supervisor/supervisord.conf"]
