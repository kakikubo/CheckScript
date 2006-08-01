#!/bin/sh

# $Id$
PATH=$PATH:/usr/local/bin:/bin:/sbin:/usr/local/sbin:/usr/bin;export PATH
MAILTO='kakikubo@sra-osc.ne.jp'

Chkport(){
   perl ./chkport.pl $1 $2 >/dev/null 2>&1 || mail -s "Check Host: $1  Service: $2" ${MAILTO} <<- EOF
	${DATE}  ${HOST}
	----------------------------------------------------------------------
	"Check Service: $2"


	EOF
}

## Chkport host service
Chkport puku ssh 
Chkport hoge ssh
Chkport hoge pgsql

exit 0
