#!/bin/bash
export DATA_SOURCE_NAME="root:$MYSQL_ROOT_PASSWORD@(localhost:3306)/"
mysqld_exporter
