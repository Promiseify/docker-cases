FROM mysql:8.0

RUN microdnf update -y && \
    microdnf install -y keepalived && \
    microdnf clean all

# 复制配置文件
COPY my.cnf /etc/mysql/conf.d/
