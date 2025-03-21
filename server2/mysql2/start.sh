#!/bin/bash

# 启动keepalived
/usr/sbin/keepalived -n &

# 等待几秒确保keepalived启动
sleep 5

# 启动MySQL
docker-entrypoint.sh mysqld --daemonize

# 等待MySQL启动完成
sleep 10

# 执行从库初始化脚本
/init-slave.sh &

# 保持MySQL在前台运行
exec mysqld