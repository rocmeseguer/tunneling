#!/bin/bash
#
#   http://manpages.ubuntu.com/manpages/xenial/en/man8/tc-fq_codel.8.html
#   https://www.bufferbloat.net/projects/codel/wiki/RRUL_Rogues_Gallery/
#   http://netseminar.stanford.edu/seminars/Inside_Codel_and_Fq_Codel.pdf
#

TC=/sbin/tc
IF=enx00e04c534458		    # Interface 
DNLD=1.72mbit 

start() {
   $TC qdisc add dev $IF root handle 1: htb default  1
   $TC class add dev $IF parent 1: classid 1:1 htb rate $DNLD
   $TC qdisc add dev $IF parent 1:1 fq_codel limit 300
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

    echo -n "Starting CODEL shaping: "
    start
    echo "done"
    ;;

  stop)

    echo -n "Stopping CODEL shaping: "
    stop
    echo "done"
    ;;

  restart)

    echo -n "Restarting CODEL shaping: "
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
    echo "Usage: $(/usr/bin/dirname $pwd)/tc_codel.bash {start|stop|restart|show}"
    ;;

esac

exit 0

