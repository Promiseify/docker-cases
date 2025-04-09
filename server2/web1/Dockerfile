FROM nginx:alpine

USER root

# 安装Zabbix Agent
RUN apk update && \
    apk add zabbix-agent && \
    mkdir -p /etc/zabbix && \
    mkdir -p /var/log/zabbix && \
    mkdir -p /var/run/zabbix

COPY nginx.conf /etc/nginx/nginx.conf
COPY html/ /usr/share/nginx/html/
COPY zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf

RUN chmod 644 /etc/zabbix/zabbix_agentd.conf

EXPOSE 80 10050

# 修改启动命令以同时启动nginx和zabbix-agent
CMD sh -c "zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf && nginx -g 'daemon off;'"