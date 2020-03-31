FROM ubuntu:16.04

RUN cat /etc/apt/sources.list
#install test tool
RUN apt-get update ; \
    apt-get install -y wget curl vim && rm -rf /var/lib/apt/lists/*

ENV GOSU_VERSION 1.7
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	#&& gpgconf --kill all \
	&& rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true
	#&& apt-get purge -y --auto-remove ca-certificates wget

#install base app (php nginx supervisor)
RUN apt-get update ; \
    apt-get install -y software-properties-common ; \
    add-apt-repository -y ppa:ondrej/php ; \ 
    gpg --keyserver keyserver.ubuntu.com --recv 4F4EA0AAE5267A6C ; \
    gpg --export --armor 4F4EA0AAE5267A6C  | apt-key add - ; \
    apt-get update ; \
    apt-get install -y supervisor apache2 php7.1-dom php7.1-xml php7.1-json php7.1-fpm libapache2-mod-php7.1 php7.1-common php7.1-gd php7.1-mysql php7.1-curl php7.1-intl php7.1-xsl php7.1-mbstring php7.1-zip php7.1-bcmath php7.1-iconv php7.1-soap && rm -rf /var/lib/apt/lists/* ; \
    sed -i '656c post_max_size = 512M' /etc/php/7.1/*/php.ini ; \
    sed -i '809c upload_max_filesize = 512M' /etc/php/7.1/*/php.ini ; \
    sed -i '404c memory_limit = 2G' /etc/php/7.1/*/php.ini ; \
    sed -i '383c max_execution_time = 180' /etc/php/7.1/*/php.ini ; \
    mkdir /run/php/ ; \
    rm /var/www/* -fr

#install mysql
RUN echo mysql-server-5.7 mysql-server/root_password password " " | debconf-set-selections \ 
        && echo mysql-server-5.7 mysql-server/root_password_again password " " | debconf-set-selections \
        && apt-get update && apt-get install -y mysql-server-5.7 && rm -rf /var/lib/apt/lists/* \
        && rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
        && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
        && chmod 777 /var/run/mysqld \
#        && find /etc/mysql/ -name '*.cnf' -print0 \
#                | xargs -0 grep -lZE '^(bind-address|log)' \
#                | xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/' \
        && echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf

COPY docker-entrypoint.sh mysql_startup.sh /usr/bin/
COPY supervisord.conf /etc/supervisor/supervisord.conf
RUN ln -s usr/bin/docker-entrypoint.sh /entrypoint.sh 
#ENTRYPOINT ["docker-entrypoint.sh"]

#$#EXPOSE 3306 80 8080
#CMD ["-c","/etc/supervisor/supervisord.conf"]
