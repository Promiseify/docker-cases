#!/bin/bash

# 设置变量
VIP="10.0.0.10"  # 使用主机的 IP 地址
INTERFACE="eth0"   # 使用主机的网络接口
SUBNET="24"
REAL_SERVERS=(
    "172.16.0.13:80"
    "172.16.0.14:80"
)

# 加载必要的内核模块
modprobe ip_vs
modprobe ip_vs_rr
modprobe nf_conntrack

# 配置网络参数
echo 1 > /proc/sys/net/ipv4/ip_forward

# 设置IPVS规则
ipvsadm -C
ipvsadm -A -t $VIP:80 -s rr
for rs in "${REAL_SERVERS[@]}"; do
    echo "Adding real server: $rs"
    ipvsadm -a -t $VIP:80 -r $rs -m  # 使用 NAT 模式
done

echo "Configuration completed:"
ipvsadm -Ln

# 监控循环
while true; do
    echo "$(date) - Current status:"
    ipvsadm -Ln
    sleep 30
done