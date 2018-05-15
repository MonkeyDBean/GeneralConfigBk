#!/bin/bash
REDIS_LOCAL_IP=$(ifconfig |awk '/inet .* Bcast/{print $2}'|cut -d ":" -f 2)

function  Conf_Reset()
{
    #--system--#
    #passwd root
    echo $SSH_ROOT_PASSWORD|passwd --stdin root
    #change time zone
    rm -vf /etc/localtime && cp /usr/share/zoneinfo/Asia/$SYSTEM_TIME_ZONE /etc/localtime

    #--redis--#
    #local bind ip
    sed -i "s/bind .*/bind $REDIS_LOCAL_IP/g" /etc/redis.conf
    #master ip port
    sed -i "s/sentinel monitor mymaster .*/sentinel monitor mymaster $REDIS_MASTER_IP 7000 2 /g"    /etc/sentinel.conf
    #passwd
    sed -i "s/sentinel auth-pass mymaster .*/sentinel auth-pass mymaster $REDIS_MASTER_PASSWD/g"    /etc/sentinel.conf
    sed -i "s/masterauth .*/masterauth $REDIS_MASTER_PASSWD/g"   /etc/redis.conf
    sed -i "s/requirepass .*/requirepass $REDIS_LOCAL_PASSWD/g" /etc/redis.conf
    #redis_type
    REDIS_TYPE=$(echo -e $REDIS_TYPE|tr a-z A-Z) && echo -e "export REDIS_TYPE=$REDIS_TYPE" >> /etc/profile
    if [[ $REDIS_TYPE = "SLAVE"  ]];then
        echo "slaveof $REDIS_MASTER_IP 7000 " >>  /etc/redis.conf
    fi

    #delete function exec
    sed -i "s/Conf_Reset && //g" /root/start.sh
}

function  Redis_Deploy()
{
    if [[ ! -f /data/redis/rdb/appendonly.aof ]];then
        echo -e "rdb file not exist start exec tar xvf" >> /data/service.log
        #tar xvf
        rm -rf /data/redis && tar xvf /tmp/redis.tar.gz -C /data/ && rm -vf /tmp/redis.tar.gz
    else
        echo -e "rdb file exist " >> /data/service.log
    fi

    #delete function exec
    sed -i "s/Redis_Deploy && //g" /root/start.sh
}

function  Start_Service()
{
    #start sshd
    source /etc/profile && /etc/init.d/sshd start
    #start redis
    if [[ $REDIS_TYPE = "MASTER"  ]] || [[ $REDIS_TYPE = "SLAVE"  ]];then
        redis-server /etc/redis.conf
    fi
    #start sentinel
    if [[ $REDIS_TYPE = "SENTINEL"  ]];then
        redis-sentinel /etc/sentinel.conf
    fi
}

#start redis
Conf_Reset && Redis_Deploy && Start_Service 
