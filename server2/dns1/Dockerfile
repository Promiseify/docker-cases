FROM centos:7

COPY Centos-7.repo /etc/yum.repos.d/CentOS-Base.repo

RUN yum -y install bind bind-utils && yum clean all

# 创建必要的目录
RUN mkdir -p /var/named/dynamic /var/named/data /run/named && \
    chown -R named:named /var/named /etc/named /run/named

COPY named.conf /etc/named.conf
COPY config/ /var/named/
COPY data/ /var/named/

EXPOSE 53/tcp 53/udp

CMD ["/usr/sbin/named", "-g", "-c", "/etc/named.conf", "-u", "named"]