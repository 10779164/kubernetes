FROM ubuntu:16.04

ENV DATADIR="/data/db" \
    BACKUP_DATADIR="/backup" \
    KUBECONFIG="/admin.conf"

COPY root/ez_setup.py root/agent/requirements.txt /
RUN apt-get update && \
    apt-get install -y apt-transport-https curl libpq-dev python3 python3-pip mysql-client-core-5.7 mysql-client-5.7 mysql-common && \
    ln -s /usr/bin/python3 /usr/bin/python && \ 
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main"  > /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl && \
    cd / && chmod +x ez_setup.py && \
    ./ez_setup.py && \
    pip3 install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir uwsgi && \
    mkdir -p /conf && \
    mkdir -p /etc/supervisor && \
    mkdir -p ${DATADIR} && \
    mkdir -p ${BACKUP_DATADIR} && \
    rm -rf /var/lib/apt/lists/* && \
    apt remove -y apt-transport-https curl && \
    apt autoremove -y && \
    apt autoclean -y 
COPY supervisor /supervisor/
RUN  cd supervisor/ && python setup.py install
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY uwsgi.ini /conf/uwsgi.ini
#COPY mysqld_exporter mysqld_exporter.sh mongo/bin/* /usr/local/bin/
COPY root /

CMD ["supervisord","-c","/etc/supervisor/supervisord.conf"]
