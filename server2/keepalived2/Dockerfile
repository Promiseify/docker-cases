FROM debian:bullseye

RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main non-free contrib" > /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y keepalived ipvsadm iproute2 --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY init-keepalived.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-keepalived.sh

CMD ["/usr/local/bin/init-keepalived.sh"]