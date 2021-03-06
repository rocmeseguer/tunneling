#!/bin/bash
#
# https://linux.die.net/man/8/tc-sfq
#

TC=/sbin/tc
IF=enx00e04c534458		    # Interface 
DNLD=1.72mbit 

start() {
    $TC qdisc add dev $IF root handle 1: htb default  1
    $TC class add dev $IF parent 1: classid 1:1 htb rate $DNLD
    $TC qdisc add dev $IF parent 1:1 sfq perturb 10
    show
}

stop() {

    $TC qdisc del dev $IF root

}

restart() {

    stop
    sleep 1
    start

}

show() {

    $TC -s qdisc ls dev $IF

}

case "$1" in

  start)

    echo -n "Starting SFQ shaping: "
    start
    echo "done"
    ;;

  stop)

    echo -n "Stopping SFQ shaping: "
    stop
    echo "done"
    ;;

  restart)

    echo -n "Restarting SFQ shaping: "
    restart
    echo "done"
    ;;

  show)
    	    	    
    echo "qdisc status for $IF:"
    show
    echo ""
    ;;

  *)

    pwd=$(pwd)
    echo "Usage: $(/usr/bin/dirname $pwd)/tc_sfq.bash {start|stop|restart|show}"
    ;;

esac

exit 0

