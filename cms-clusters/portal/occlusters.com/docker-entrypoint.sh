#!/bin/bash
export PATH=$PATH:/usr/bin
ln -s /configfile/portal.conf /etc/nginx/sites-enabled/portal.conf
ln -sf /data/portal /var/www/html

set -- supervisord "$@"
exec "$@"
