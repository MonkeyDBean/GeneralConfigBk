FROM centos6:v1
MAINTAINER Operation

#Setting redis environment virable
ENV	REDIS_LOCAL_PASSWD	123456
ENV	REDIS_MASTER_PASSWD	123456
ENV	REDIS_TYPE			master
ENV	REDIS_MASTER_IP		172.17.0.2
	

#Install redis
ADD lib/redis-3.2.11.tar.gz /tmp
ADD lib/redis_conf.tar.gz /etc/
RUN  yum -y localinstall \
    /tmp/jemalloc-3.6.0-1.el6.x86_64.rpm \
    /tmp/redis-3.2.11-1.el6.x86_64.rpm \
    && rm -vf /tmp/*.rpm \
    && mkdir -p /data/redis/{log,rdb} \
    && cd /data/ && tar zcvf /tmp/redis.tar.gz redis && rm -rf /data/redis


COPY lib/start.sh /root/start.sh
CMD ["/bin/bash","/root/start.sh"]


EXPOSE 22
EXPOSE 7000
EXPOSE 7003
