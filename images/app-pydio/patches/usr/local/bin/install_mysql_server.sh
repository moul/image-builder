#!/bin/bash

if [ ! -f /root/.my.cnf ]; then
    username="root"
    dbname="pydio"
    password=$(pwgen 42)
    cat <<EOF > /root/.my.cnf
[client]
user = root
password = $password
EOF

    # Reset mysql root password
    cat <<EOF > /tmp/recover_root_mysql.ini
UPDATE mysql.user SET password=PASSWORD("$password") where User='$username';
FLUSH PRIVILEGES;
EOF
    service mysql stop
    mysqld_safe --skip-grant-tables --init-file=/tmp/recover_root_mysql.ini &
    sleep 5
    echo "CREATE DATABASE $dbname" | mysql -u $username -p$password
    killall mysqld
    rm -f /tmp/recover_root_mysql.ini
    service mysql start
fi
