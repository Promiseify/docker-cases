FROM debian:bullseye

# 使用清华源
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main non-free contrib" > /etc/apt/sources.list

# 更新并安装软件包
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    perl-base=5.32.1-4+deb11u4 \
    perl=5.32.1-4+deb11u3 \
    keepalived \
    ipvsadm \
    iproute2 \
    netcat && \
    rm -rf /var/lib/apt/lists/*

COPY init-keepalived.sh /usr/local/bin/
COPY check_mysql.sh /etc/keepalived/

RUN chmod +x /usr/local/bin/init-keepalived.sh \
    && chmod +x /etc/keepalived/check_mysql.sh

CMD ["/usr/local/bin/init-keepalived.sh"]