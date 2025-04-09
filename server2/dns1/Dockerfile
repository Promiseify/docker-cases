FROM centos:7

COPY Centos-7.repo /etc/yum.repos.d/CentOS-Base.repo

RUN yum -y install bind bind-utils && \
    yum install -y epel-release && \
    yum install -y zabbix-agent && \
    yum clean all && \
    mkdir -p /etc/zabbix && \
    mkdir -p /var/log/zabbix && \
    mkdir -p /var/run/zabbix

# 创建必要的目录
RUN mkdir -p /var/named/dynamic /var/named/data /run/named && \
    chown -R named:named /var/named /etc/named /run/named

COPY named.conf /etc/named.conf
COPY config/ /var/named/
COPY data/ /var/named/
COPY zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf
RUN chmod 644 /etc/zabbix/zabbix_agentd.conf

EXPOSE 53/tcp 53/udp 10050

# 使用直接命令启动而不是service
CMD sh -c "zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf && /usr/sbin/named -g -c /etc/named.conf -u named"