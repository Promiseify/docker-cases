## 使用 dig 命令测试正向解析

```shell
# 测试主 DNS 服务器
dig @172.16.0.8 www.zhida.com

# 测试从 DNS 服务器
dig @172.16.0.9 www.zhida.com

# 如果您映射了端口（例如 5353），则使用：
dig @127.0.0.1 -p 5353 www.zhida.com
```

成功的输出应该显示 10.0.0.10 作为 www.zhida.com 的 IP 地址。

## 测试反向解析

```shell
# 测试 VIP 的反向解析
dig @172.16.0.8 -x 10.0.0.10
dig @172.16.0.8 -x 10.0.0.20

# 测试内部 IP 的反向解析
dig @172.16.0.8 -x 172.16.0.13
dig @172.16.0.8 -x 172.16.0.21
```

成功的输出应该显示相应的域名。

## 测试 DNS 服务器之间的区域传输

```shell
# 检查从服务器是否成功从主服务器获取区域数据
docker exec -it dns2 ls -la /var/named/slaves/
```

## 在容器内部测试 DNS 解析

```shell
# 进入 web1 容器
docker exec -it web1 bash

# 安装 dig 工具（如果没有）
apt-get update && apt-get install -y dnsutils

# 测试 DNS 解析
dig @172.16.0.8 www.zhida.com
```

```yaml
  web1:
    build: ./web1
    ports:
      - "8081:80"
    networks:
      app_net:
        ipv4_address: 172.16.0.13
    dns:
      - 172.16.0.8
      - 172.16.0.9
```

## 测试 DNS 负载均衡（如果配置了）

```shell
# 测试 DNS VIP
dig @10.0.0.10 www.zhida.com
```

## 使用 nslookup 测试（更简单的方式）

```shell
# 使用主 DNS 服务器
nslookup www.zhida.com 172.16.0.8

# 使用从 DNS 服务器
nslookup www.zhida.com 172.16.0.9
```

## Zabbix监控系统

### 部署说明
1. 确保Docker和Docker Compose已安装
2. 在server2目录下运行:
   ```bash
   docker-compose up -d
   ```

### 访问方式
- Zabbix Web界面: http://your-server-ip
- 默认登录凭据:
  - 用户名: Admin
  - 密码: zabbix

### 端口说明
- 80: Zabbix Web界面
- 10051: Zabbix服务器端口

### 数据持久化
- MySQL数据存储在 ./zbx_db_data 目录

