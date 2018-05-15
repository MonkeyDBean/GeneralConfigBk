FROM centos6:v1
MAINTAINER Develop

ENV MYSQL_HOST 127.0.0.1
ENV MYSQL_PORT 3306
ENV MYSQL_USER root
ENV MYSQL_PASSWORD 123456
ENV MYSQL_CHARACTER_SET utf8

#-------------
# ADD sql file
#-------------
ADD /sql/01-init.sql /root/
# -----------------------------------------------------------------------------
# MySQL client
# -----------------------------------------------------------------------------
RUN	yum -y update \
	&& yum --setopt=tsflags=nodocs -y install \
	mysql \
	&& rm -rf /var/cache/yum/* \
	&& yum clean all

WORKDIR /root
CMD mysql -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u ${MYSQL_USER} -p${MYSQL_PASSWORD} --default-character-set=${MYSQL_CHARACTER_SET} < 01-service_bus_init.sql
