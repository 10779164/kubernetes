#!/bin/bash
mysqld && mysql -u root -psean -e "CREATE DATABASE wordpress;GRANT ALL PRIVILEGES ON wordpress.* TO '"wordpress"'@'"%"' IDENTIFIED BY '"password"';FLUSH PRIVILEGES;"
