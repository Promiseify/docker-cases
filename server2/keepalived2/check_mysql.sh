#!/bin/bash

# keepalived2对应mysql2，只检查本地MySQL实例
MYSQL_HOST="172.16.0.22"  # mysql2的地址
MYSQL_PORT="3306"

# 使用nc检查MySQL端口
nc -z -w1 ${MYSQL_HOST} ${MYSQL_PORT} &>/dev/null

# 获取退出状态
EXIT_CODE=$?

if [ ${EXIT_CODE} -eq 0 ]; then
    # MySQL端口可访问
    exit 0
else
    # MySQL端口不可访问
    exit 1
fi