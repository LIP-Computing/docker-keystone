#!/bin/bash

tempSqlFile='/tmp/ks.sql'
cat > "$tempSqlFile" <<-EOSQL
    CREATE DATABASE IF NOT EXISTS keystone ;
    GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
    GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
    FLUSH PRIVILEGES;
EOSQL

mysql -h ${MYSQL_HOST} --password=${MYSQL_PASSWORD} < ${tempSqlFile}

su -s /bin/sh -c "keystone-manage db_sync" keystone
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
