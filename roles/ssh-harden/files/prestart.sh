#!/bin/sh
#
# chkconfig: 2345 50 80
# description: ssh pre scripts
# processname: ssh-prestart
#

### BEGIN INIT INFO
# Provides: ssh-prestart
# Required-Start: $local_fs $network
# Required-Stop: $local_fs $network
# Should-Start: ssh-prestart
# Should-Stop: ssh-prestart
# X-Start-Before: sshd
# Default-Start: 2 3 5
# Default-Stop: 0 1 6
# Short-Description: Run ssh pre scripts before agent
# Description: ssh agent pre scripts
### END INIT INFO




declare -i NO_MGMT_BIND=1


start()
{
  [ -e /etc/sysconfig/sshd ] && . /etc/sysconfig/sshd
  if [ "$NO_MGMT_BIND" == "1" ] ; then
    echo "Starting ssh-prestart"
    ip=$(/sbin/ip addr show mgmt | awk '/ inet / { gsub(/\/[0-9]+$/,"",$2); print $2}' )
    ip2=$(/sbin/ip addr show build | awk '/ inet / { gsub(/\/[0-9]+$/,"",$2); print $2}' )
    if [[ $ip =~ [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+ ]] ; then
      sed -e "s/^\s*ListenAddress.*/#& # removed by ssh-pre service/" -i /etc/ssh/sshd_config
      sed -e "s/Port 22/&\nListenAddress $ip/" -i /etc/ssh/sshd_config
    fi
    if [[ $ip2 =~ [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+ ]] ; then
      sed -e "s/Port 22/&\nListenAddress $ip2/" -i /etc/ssh/sshd_config
    fi
  fi

}

stop()
{
  echo -n "Stopping ssh-prestart"
}

restart()
{
    stop
    start
}

case "$1" in
    start|stop|restart)
        $1
        ;;
    force-reload)
        restart
        ;;
    status)
        exit 0
        ;;
    try-restart|condrestart)
        if status $prog >/dev/null ; then
            restart
        fi
        ;;
    reload)
        action $"Service ${0##*/} does not support the reload action: " /bin/false
        exit 3
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|try-restart|force-reload}"
        exit 2
        ;;
esac

