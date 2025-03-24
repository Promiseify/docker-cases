#!/bin/bash

# MySQL 主库和从库的地址和端口
MYSQL_MASTER_HOST="172.16.0.21"
MYSQL_SLAVE_HOST="172.16.0.22"
MYSQL_PORT="3306"
MYSQL_USER="root"
MYSQL_PASS="root123"

# 检查主库是否可用
mysqladmin -h $MYSQL_MASTER_HOST -P $MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASS ping > /dev/null 2>&1

# 如果主库不可用，检查从库是否可用
if [ $? -ne 0 ]; then
    mysqladmin -h $MYSQL_SLAVE_HOST -P $MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASS ping > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        exit 0  # 从库健康
    else
        exit 1  # 主从库都不可用
    fi
else
    exit 0  # 主库健康
fi