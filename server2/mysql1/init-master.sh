#!/bin/bash

# 等待MySQL服务启动
until mysqladmin ping -h"localhost" -uroot -p"123456" --silent; do
    echo "等待MySQL主库启动..."
    sleep 2
done

echo "配置主库..."
mysql -uroot -p"123456" <<EOF
CREATE USER IF NOT EXISTS 'repl'@'%' IDENTIFIED BY 'repl_password';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
FLUSH PRIVILEGES;

# 创建测试数据库和表
CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOF

echo "主库配置完成"