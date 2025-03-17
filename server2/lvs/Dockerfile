FROM ubuntu:22.04

# 安装必要的包
RUN apt-get update && apt-get install -y \
    ipvsadm \
    iproute2 \
    curl \
    net-tools \
    keepalived \
    && rm -rf /var/lib/apt/lists/*

# 配置初始化脚本
COPY lvs-init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/lvs-init.sh

# 使用初始化脚本作为入口点
CMD ["/usr/local/bin/lvs-init.sh"]