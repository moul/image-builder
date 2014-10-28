#!/bin/bash

if [ ! -f /root/.my.cnf ]; then
    password=$(pwgen 42)
    cat <<EOF > /root/.my.cnf
[client]
user = root
password = $password
EOF
    echo "mysql-server mysql-server/root_password password $password" debconf-set-selections
    echo "mysql-server mysql-server/root_password_again password $password" debconf-set-selections
    apt-get install -qy mysql-server
fi

echo "CREATE DATABASE pydio" | mysql

