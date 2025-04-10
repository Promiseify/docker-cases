FROM debian:bullseye

RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main non-free contrib" > /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    --allow-downgrades --allow-change-held-packages \
    keepalived ipvsadm iproute2 mariadb-client && \
    rm -rf /var/lib/apt/lists/*

COPY init-keepalived.sh /usr/local/bin/
COPY check_mysql.sh /etc/keepalived/

RUN chmod +x /usr/local/bin/init-keepalived.sh \
    && chmod +x /etc/keepalived/check_mysql.sh

CMD ["/usr/local/bin/init-keepalived.sh"]