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

    while ! [[ "$mysqld_process_pid" =~ ^[0-9]+$ ]]; do
	mysqld_process_pid=$(echo "$(ps -C mysqld -o pid=)" | sed -e 's/^ *//g' -e 's/ *$//g')
	sleep 1
    done

    echo "CREATE DATABASE $dbname" | mysql -u $username -p$password

    rm -f /tmp/recover_root_mysql.ini
    killall mysqld
    sleep 5
    killall -9 mysqld

    service mysql start
fi
