FROM centos6:v1
MAINTAINER Operation

#Setting mysql environment virable
ENV MYSQL_ROOT_PASSWORD     123456
ENV MYSQL_READ_USER         mysql_read
ENV MYSQL_READ_PASSWORD     123456
ENV MYSQL_WRITE_USER        mysql_write
ENV MYSQL_WRITE_PASSWORD    123456

#Install mysql
ADD  lib/Percona-Server-5.6.38-el6.tar.gz /tmp
COPY lib/my.cnf /etc
RUN  yum -y localinstall \
    /tmp/Percona-Server-shared-56-5.6.38-rel83.0.el6.x86_64.rpm \
    /tmp/Percona-Server-client-56-5.6.38-rel83.0.el6.x86_64.rpm \
    /tmp/Percona-Server-server-56-5.6.38-rel83.0.el6.x86_64.rpm \
    && rm -vf /tmp/*.rpm \
    && mkdir -p /data/mysql/data /data/mysql/log && touch /data/mysql/log/mysqld.log \
    && cd /data/ && tar zcvf /tmp/percona_5.6.38.tar.gz mysql && rm -rf /data/mysql


COPY lib/start.sh /etc/init.d/start.sh
CMD ["/etc/init.d/start.sh"]

EXPOSE 22
EXPOSE 3306
