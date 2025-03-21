#!/bin/bash

# 获取默认网卡名称
INTERFACE=$(ip route | grep default | awk '{print $5}')

# 如果没有找到默认网卡，尝试获取第一个非lo的网卡
if [ -z "$INTERFACE" ]; then
    INTERFACE=$(ip link show | grep -v lo | grep -v docker | grep -v bridge | grep UP | head -n 1 | awk -F: '{print $2}' | tr -d ' ')
fi

echo "Using interface: $INTERFACE"

# 生成 keepalived 配置文件
cat > /etc/keepalived/keepalived.conf << EOF
vrrp_instance VI_1 {
    state BACKUP
    interface $INTERFACE
    virtual_router_id 51
    priority 90
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 123456
    }
    virtual_ipaddress {
        10.0.0.10/8
    }
    notify_master "/bin/sh -c 'ipvsadm -C && ipvsadm -A -t 10.0.0.10:80 -s rr && ipvsadm -a -t 10.0.0.10:80 -r 172.16.0.13:80 -m && ipvsadm -a -t 10.0.0.10:80 -r 172.16.0.14:80 -m'"
}
EOF

# 启动 keepalived
exec keepalived -n -l -D -f /etc/keepalived/keepalived.conf