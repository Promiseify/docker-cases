FROM ubuntu:22.04

# 安装必要的包
RUN apt-get update && apt-get install -y \
    ipvsadm \
    iproute2 \
    curl \
    net-tools \
    kmod \
    procps \
    nfs-common \
    ntpdate \
    && rm -rf /var/lib/apt/lists/*
# 配置初始化脚本
COPY lvs-init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/lvs-init.sh

# 预创建目录
RUN mkdir -p /proc/sys/net/ipv4

EXPOSE 80

# 使用初始化脚本作为入口点
CMD sh -c "/usr/local/bin/lvs-init.sh"
