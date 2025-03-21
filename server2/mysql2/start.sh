#!/bin/bash

MYSQL_ROOT_PWD="123456"
MYSQL1_HOST="10.0.0.21" # 根据你 mysql1 的 IP 修改

# 创建 repl 用户
mysql -uroot -p${MYSQL_ROOT_PWD} -e "CREATE USER 'repl'@'10.0.0.%' IDENTIFIED WITH mysql_native_password BY 'repl_password';"
mysql -uroot -p${MYSQL_ROOT_PWD} -e "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'10.0.0.%';"
mysql -uroot -p${MYSQL_ROOT_PWD} -e "FLUSH PRIVILEGES;"

MASTER_STATUS=$(mysql -uroot -p${MYSQL_ROOT_PWD} -h ${MYSQL1_HOST} -e "SHOW MASTER STATUS\G")
MASTER_FILE=$(echo "$MASTER_STATUS" | grep 'File' | awk '{print $2}')
MASTER_POS=$(echo "$MASTER_STATUS" | grep 'Position' | awk '{print $2}')

# 检查是否获取到文件和位置
if [ -z "$MASTER_FILE" ] || [ -z "$MASTER_POS" ]; then
  echo "无法获取 master 的 File 和 Position 信息"
  exit 1
fi

echo "获取到的 master 文件：$MASTER_FILE, 位置：$MASTER_POS"

mysql -uroot -p${MYSQL_ROOT_PWD} -e "CHANGE MASTER TO MASTER_HOST='${MYSQL1_HOST}', MASTER_USER='repl', MASTER_PASSWORD='repl_password', MASTER_LOG_FILE='${MASTER_FILE}', MASTER_LOG_POS=${MASTER_POS};"
mysql -uroot -p${MYSQL_ROOT_PWD} -e "START SLAVE;"

echo "已完成从库配置并启动 slave"

# 保持MySQL在前台运行
exec mysqld