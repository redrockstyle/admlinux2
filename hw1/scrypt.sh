#!/bin/bash
### BEGIN INIT INFO
# Provides:             monitor
# Required-strt:        $all
# Required-stop:        $all
# Default-start:        2 3 4 5
# Default-stop:         0 1 6
# Short-Description:Start monitor at boot time
### END INIT INFO
case $1 in
        start)
                echo start + date >> /var/log/monitor.log
                /opt/mydemon.sh & 
                echo $! > /var/run/mydemon.pid
        ;;
        stop)
                echo stop + date >> /var/log/monitor.log
                kill $(cat /var/run/mydemon.pid)
                rm /var/run/mydemon.pid
        ;;
        restart)
                $0 stop
                $0 start
        ;;
        status)
                if [ -e /var/run/mydemon.pid ]; then
                        echo mydemon is running, pid=$(cat /var/run/mydemon.pid)
                else
                        echo mydemon is NOT running
                        exit 1
                fi
        ::
        *)
                echo start + date >> /var/log/monitor.log
                /opt/mydemon.sh &
                echo $! > /var/run/mydemon.pid
        ;;
esac
exit 0
