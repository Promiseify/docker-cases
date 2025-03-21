#!/bin/bash

MYSQL_ROOT_PWD="123456"

mysql -uroot -p${MYSQL_ROOT_PWD} -e "CREATE USER 'repl'@'10.0.0.%' IDENTIFIED WITH mysql_native_password BY 'repl_password';"
mysql -uroot -p${MYSQL_ROOT_PWD} -e "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'10.0.0.%';"
mysql -uroot -p${MYSQL_ROOT_PWD} -e "FLUSH PRIVILEGES;"
mysql -uroot -p${MYSQL_ROOT_PWD} -e "SHOW MASTER STATUS\G" > /tmp/mysql1_master_status.txt

echo "mysql1 master 配置完成，状态在 /tmp/mysql1_master_status.txt"

# 保持MySQL在前台运行
exec mysqld