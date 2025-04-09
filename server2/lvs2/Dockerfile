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
    zabbix-agent \
    && rm -rf /var/lib/apt/lists/*

# 确保目录存在
RUN mkdir -p /etc/zabbix && \
    mkdir -p /var/log/zabbix && \
    mkdir -p /var/run/zabbix

# 配置初始化脚本
COPY lvs-init.sh /usr/local/bin/
COPY zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf
RUN chmod +x /usr/local/bin/lvs-init.sh
RUN chmod 644 /etc/zabbix/zabbix_agentd.conf

# 预创建目录
RUN mkdir -p /proc/sys/net/ipv4

EXPOSE 80 10050

# 修改启动命令以同时启动lvs和zabbix-agent
CMD sh -c "service zabbix-agent start && /usr/local/bin/lvs-init.sh"