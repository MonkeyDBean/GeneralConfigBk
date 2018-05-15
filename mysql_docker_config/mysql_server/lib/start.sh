#!/bin/bash

function  Conf_Reset()
{
    #passwd root
    echo $SSH_ROOT_PASSWORD|passwd --stdin root
    #change time zone
    rm -vf /etc/localtime && cp /usr/share/zoneinfo/Asia/$SYSTEM_TIME_ZONE /etc/localtime
}

function  Mysql_Grant()
{
    #tar xvf mysql
    tar xvf /tmp/percona_5.6.38.tar.gz -C /data/ && rm -vf /tmp/percona_5.6.38.tar.gz
    chown mysql.mysql /data/mysql
    /etc/init.d/mysql start
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
    #delete mysql user
    for i in `mysql -e "select * from mysql.user \G"|grep -i 'Host:'|awk '{print $2}'`;do mysql -e "DELETE FROM mysql.user WHERE USER='' AND HOST='${i}';";done
    for i in `mysql -e "select * from mysql.user \G"|grep -iB1 'root'|awk '/Host/{print $2}'|grep -v '%'`;do mysql -e "DELETE FROM mysql.user WHERE USER='root' AND HOST='${i}';";done
    #grant user
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_READ_USER'@'%' IDENTIFIED BY '$MYSQL_READ_PASSWORD';"
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_WRITE_USER'@'%' IDENTIFIED BY '$MYSQL_WRITE_PASSWORD';"
    /etc/init.d/mysql stop
}

#start sshd
/etc/init.d/sshd start

#start mysql
Conf_Reset && Mysql_Grant && /usr/sbin/mysqld
