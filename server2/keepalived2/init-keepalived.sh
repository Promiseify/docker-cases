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
global_defs {
   enable_script_security
   script_user root
}

vrrp_script chk_mysql {
    script "/etc/keepalived/check_mysql.sh"
    interval 2
    weight -50
    fall 1
    rise 1
}

vrrp_instance VI_WEB {
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

# MySQL 实例配置
vrrp_instance VI_DB {
    state BACKUP
    interface $INTERFACE
    virtual_router_id 21
    priority 90
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 123456
    }
    virtual_ipaddress {
        172.16.0.100/16
    }
    track_script {
        chk_mysql
    }
    notify_master "/bin/sh -c 'ipvsadm -A -t 172.16.0.100:3306 -s rr && \
        ipvsadm -a -t 172.16.0.100:3306 -r 172.16.0.21:3306 -m && \
        ipvsadm -a -t 172.16.0.100:3306 -r 172.16.0.22:3306 -m'"
    notify_backup "/bin/sh -c 'ipvsadm -D -t 172.16.0.100:3306'"
    notify_fault "/bin/sh -c 'ipvsadm -D -t 172.16.0.100:3306'"
}
EOF

# 启动 keepalived
exec keepalived -n -l -D -f /etc/keepalived/keepalived.conf