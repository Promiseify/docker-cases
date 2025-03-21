FROM mysql:8.0

# 安装keepalived
RUN microdnf update -y && \
    microdnf install -y keepalived && \
    microdnf clean all

# 创建必要的目录
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld

# 复制配置文件
COPY my.cnf /etc/mysql/conf.d/
COPY keepalived.conf /etc/keepalived/
COPY start.sh /start.sh
COPY init-slave.sh /init-slave.sh

RUN chmod +x /start.sh /init-slave.sh

CMD ["/start.sh"]