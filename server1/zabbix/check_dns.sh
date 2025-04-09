#!/bin/bash

# 检查DNS服务状态
check_named_status() {
    systemctl is-active named >/dev/null 2>&1
    echo $?
}

# 检查DNS响应时间
check_dns_response() {
    local domain=$1
    dig @localhost $domain | grep "Query time:" | awk '{print $4}'
}

# 检查区域传输
check_zone_transfer() {
    local zone=$1
    dig @localhost $zone AXFR >/dev/null 2>&1
    echo $?
}

case "$1" in
    named.status)
        check_named_status
        ;;
    dns.response)
        check_dns_response $2
        ;;
    zone.transfer)
        check_zone_transfer $2
        ;;
    *)
        echo "Usage: $0 {named.status|dns.response|zone.transfer}"
        exit 1
        ;;
esac