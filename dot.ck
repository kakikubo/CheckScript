#
#
#

SYSLOG="/var/log/messages \
	/var/log/messages.0.gz"

LOG="/var/log/xdm.log"

PROCESS="httpd
	lpd"

#SUDO="yes"


IG1='hoge'
IG2='nmbd'
IG3='/kernel'
IGNORE="($IG1|$IG2|$IG3)"

#IGNORE='=Sent|from=|NOQUEUE: Null connection from \[10.230.8.36\]'
#checklog.sh:        egrep "($DAY|$MON)" $i | egrep -v "($IGNORE)" | more
