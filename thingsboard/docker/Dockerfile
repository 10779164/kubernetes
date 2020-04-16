FROM ubuntu:16.04
#FROM debian:buster-slim

#thingsboard
RUN apt update; \
	mkdir -p /usr/share/man/man1; \
	apt install openjdk-8-jdk supervisor wget -y; \
	update-alternatives --config java

WORKDIR /root
RUN wget https://github.com/thingsboard/thingsboard/releases/download/v2.4.3/thingsboard-2.4.3.deb

#postgresql
RUN apt-get update; \
	apt-get install postgresql -y

#ENV PGDATA /data/db
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432 9001 8080
CMD ["-c","/etc/supervisor/supervisord.conf"]
