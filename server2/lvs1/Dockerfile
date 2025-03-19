FROM ubuntu:22.04

# 安装必要的包
RUN apt-get update && apt-get install -y \
    ipvsadm \
    iproute2 \
    curl \
    net-tools \
    keepalived \
    kmod \
    procps \
    && rm -rf /var/lib/apt/lists/*
# 配置初始化脚本
COPY lvs-init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/lvs-init.sh

# 复制Keepalived配置文件
COPY keepalived.conf /etc/keepalived/keepalived.conf

# 预创建目录
RUN mkdir -p /proc/sys/net/ipv4

EXPOSE 80

# 使用初始化脚本作为入口点
CMD sh -c "keepalived -n & /usr/local/bin/lvs-init.sh"
