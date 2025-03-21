#!/bin/bash

# 等待MySQL从库启动
until mysqladmin ping -h"localhost" -uroot -p"123456" --silent; do
    echo "等待MySQL从库启动..."
    sleep 2
done

# 等待主库可访问
until mysqladmin ping -h"10.0.0.10" -uroot -p"123456" --silent; do
    echo "等待主库可访问..."
    sleep 5
done

echo "获取主库状态..."
MASTER_STATUS=$(mysql -h"10.0.0.10" -uroot -p"123456" -e "SHOW MASTER STATUS\G")
LOG_FILE=$(echo "$MASTER_STATUS" | grep File | awk '{print $2}')
LOG_POS=$(echo "$MASTER_STATUS" | grep Position | awk '{print $2}')

echo "配置从库..."
mysql -uroot -p"123456" <<EOF
STOP SLAVE;
CHANGE MASTER TO
    MASTER_HOST='10.0.0.10',
    MASTER_USER='repl',
    MASTER_PASSWORD='repl_password',
    MASTER_LOG_FILE='$LOG_FILE',
    MASTER_LOG_POS=$LOG_POS;
START SLAVE;
EOF

# 检查从库状态
echo "检查从库状态..."
mysql -uroot -p"123456" -e "SHOW SLAVE STATUS\G"