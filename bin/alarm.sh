#!/bin/bash

path=$(pwd)

help()
{
    echo "Usage: $0 [start|stop|restart]"
}

function stop()
{
    ## ActiveMQ
    cd $path/activemq/bin/linux-x86-64
    ./activemq stop

    ## jms2rdb
    killall -9 JMS2RDB
    pid_jms2rdb=$(ps -ef | grep JMS2RDB | grep -v 'grep' | awk '{print $2}')
    kill -9 $pid_jms2rdb

    ## Alarm Server
    killall -9 AlarmServer
    pid_alarm_server=$(ps -ef | grep AlarmServer | grep -v 'grep' | awk '{print $2}')
    kill -9 $pid_alarm_server
}

function start()
{
    ## ActiveMQ
    cd $path/activemq/bin/linux-x86-64
    ./activemq start

    ## jms2rdb
    cd $path/jms2rdb
    ./JMS2RDB &

    ## Alarm Server
    cd $path/alarm-server
    ./AlarmServer &
}

## See how we were called.
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    *)
        help
        exit 2
esac
