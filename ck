#! /bin/sh

# $Id$
# ck
#
# configlation file is ~/.ck



############################################################
# ¥Ñ¥¹¤Î»ØÄê¡£ÀßÄê¥Õ¥¡¥¤¥ë¤ÎÆÉ¤ß¹þ¤ß¡£LANG¤ÏC¤ò»ÈÍÑ
############################################################
PATH="/usr/local/bin/:/usr/bin:/bin" ; export PATH
. ${HOME}/.ck
#LANG=C
_HOSTNAME=`hostname | sed 's/\..*//'`


############################################################
# ¥Ú¡¼¥¸¥ã¤¬»ØÄê¤µ¤ì¤Æ¤¤¤ë¤«¤É¤¦¤«¤Î¥Á¥§¥Ã¥¯
# »ØÄê¤µ¤ì¤Æ¤¤¤Ê¤¤¾ì¹ç¤Ïmore¤ò»ÈÍÑ
# PAGER¤Ëless¤¬ÀßÄê¤µ¤ì¤Æ¤¤¤¿¾ì¹ç¤Ç³î¤Ä¡¢¥ô¥¡¡¼¥¸¥ç¥ó¤¬358°Ê¹ß¤Ç
# ¤¢¤ì¤Ð¥«¥é¡¼¥ê¥ó¥°¤¬Í­¸ú¤È¤Ê¤ë¡£
############################################################
PAGER=${PAGER:=more} ; export PAGER
#LESS=${LESS:="-E"}  ; export¤³¤ì¤Ï´í¸±¡© 
COLOR="NO" ; export COLOR

if [ ${PAGER} = "jless" -o ${PAGER} = "less" ]
then
    LESSVERSION=`${PAGER} -V | head -1 | awk '{print FS + $2}' `
    if [ ${LESSVERSION} -gt 340 ]
    then 
	LESS="-X -R "   ; export LESS
	COLOR="YES"     ; export COLOR
    fi
fi
# if [ ${PAGER} = "jless" ]
# then
#     PAGER="less -X -R"
#     export PAGER
# fi


############################################################
# sudo¤ò»ÈÍÑ¤¹¤ë°Ù¤Î´Ø¿ô¤òÄêµÁ
############################################################
UsingSudo(){
    while :
      do 
      echo "--- Please Input sra passwd for \"sudo\". ---"
      echo ""
      sudo -v 
      if [ $? -eq 0 ];then
	  echo "--- Checking sra passwd... OK! Go ahead ! ---"
	  SUDO="sudo"
	  break  
      else
	  :
      fi
      
    done
}

############################################################
#¥×¥í¥»¥¹¥Á¥§¥Ã¥¯¤Ë»ÈÍÑ¤¹¤ë¥«¥é¡¼¤òÄêµÁ(process color)
############################################################
NOR="\033[34;1m"
ERR="\033[31;40;1m"
END="\033[30;m"



############################################################
#´Ø¿ôÌ¾¡§Ostype
#µ¡Ç½  ¡§¥×¥í¥°¥é¥à¤ò¼Â¹Ô¤¹¤ë¥Û¥¹¥È¤ÎOS¤òÈ½ÊÌ¤¹¤ë¡£
#ÆþÎÏ  ¡§¤Ê¤·
#½ÐÎÏ  ¡§OS¤Î¼ïÎà
#
############################################################
Ostype(){



    case `uname -s` in
	FreeBSD )    echo FREEBSD        ;;
	Linux   )    echo LINUX          ;;
	AIX     )    echo AIX            ;;
        HP-UX   )    echo HP             ;;
	IRIX    )    echo SGI            ;;
        OSF1    )    echo DECOSF         ;;
        ULTRIX  )    echo ULTRIX         ;;
        Darwin  )    echo MacOSX         ;;
        SunOS   )    case `uname -r` in
			4*)  echo SUNBSD    ;;
			5*)  echo SOLARIS   ;;
		     esac
		     ;;
	$_HOSTNAME ) case `uname -m` in
			IP*) echo SGI       ;;
 		       i386) echo SCO       ;;
		     esac
		     ;;
    esac
}

############################################################
#´Ø¿ôÌ¾¡§¤Ê¤·
#µ¡Ç½  ¡§OS¤Ë¤è¤Ã¤Æ»ÈÍÑ¤¹¤ë¥³¥Þ¥ó¥É¤òÈ½ÊÌ
############################################################
WHATOS=`Ostype`
case "${WHATOS}" in
	FREEBSD|MacOSX|LINUX) PS='/bin/ps auxwww'
			ECHO='echo -e'
			break
			;;
	SOLARIS)PS='/bin/ps -ef'
			ECHO='echo'
			break
			;;
	*)		PS='/bin/ps -auxwww'
			ECHO='echo'
			;;
esac

############################################################
#´Ø¿ôÌ¾¡§¤Ê¤·
#µ¡Ç½  ¡§¥í¥°¥Õ¥¡¥¤¥ë¤«¤é³ºÅöÆüÉÕ¤Î¤ß¤ò¥Ô¥Ã¥¯¥¢¥Ã¥×¡£
#       ck¥³¥Þ¥ó¥É¼«ÂÎ¤Ë-[1-7]¤ò»ØÄê¤Ç¤­¤ë¡£¥Ç¥Õ¥©¥ë¥È¤Ï1¤Ç¡¢
#       ÅöÆü¡¢Á°Æü¤ò¸«¤ë¡£-7¤¬»ØÄê¤µ¤ì¤¿¾ì¹ç¤ÏÅöÆü¤«¤é7ÆüÁ°¤Þ¤Ç
#       ¥Ô¥Ã¥¯¥¢¥Ã¥×¤·¤Æ¸«¤ë¡£
#
#        ¸½ºß¤ÏËÜÆüÊ¬¤ÈºòÆüÊ¬¤Î¤ß¤ò½ÐÎÏ¤¹¤ë¤è¤¦¤ËÊÑ¹¹¤µ¤ì¤Æ¤¤¤ë¡£
############################################################

# +,-¤òÉ¬¤ºÉ½µ­¤¹¤ë¤Ë¤Ï¤³¤¦¤¹¤ë¤Î¤À¡£
# printf "%+d" "`expr 3 + 5`"
YYYY=`LANG=C date +'%Y'`
YY=`LANG=C date +'%y'`
MM=`LANG=C date +'%m'`
DD=`LANG=C date +'%d'`
# GDATE7=`date -v -7d +'%b %e'`
# GDATE6=`date -v -6d +'%b %e'`
# GDATE5=`date -v -5d +'%b %e'`
# GDATE4=`date -v -4d +'%b %e'`
# GDATE3=`date -v -3d +'%b %e'`
# GDATE2=`date -v -2d +'%b %e'`
# GDATE1=`date -v -1d +'%b %e'`
# GDATE0=`date +'%b %e'`
# OPT=
GDATE1=`env TZ=JST+15 LANG=C date +'%b %e'`
GDATE0=`env TZ=JST-9  LANG=C date +'%b %e'`
GREPDATE="${GDATE1}|${GDATE0}"

shift `expr $OPTIND - 1`

############################################################
#´Ø¿ôÌ¾¡§ Ignoring
#µ¡Ç½  ¡§É¸½àÆþÎÏ¤«¤é¼õ¤±¤¿¥Ç¡¼¥¿¤ò¾Ê¤¯
#ÆþÎÏ  ¡§¥í¥°¥Õ¥¡¥¤¥ë¤Ê¤É¤ÎÊ¸»úÎó
#½ÐÎÏ  ¡§¥Ñ¥¿¡¼¥ó¤Ë¤Ò¤Ã¤«¤«¤é¤Ê¤«¤Ã¤¿¤â¤Î°Ê³°¤Î¹Ô
#
############################################################
Ignoring(){
    if [ "${IGNORE}x" = "x" ]
    then
	cat $1
    else
	egrep -v "${IGNORE}" $1 
    fi
}


############################################################
#´Ø¿ôÌ¾¡§ ColoringStream
#µ¡Ç½  ¡§É¸½àÆþÎÏ¤«¤é¼õ¤±¤¿¥Ç¡¼¥¿¤ò°ìÄêµ¬Â§¤Ç¿§ÉÕ¤±¤·¤Æ½ÐÎÏ¤¹¤ë
#ÆþÎÏ  ¡§¥í¥°¥Õ¥¡¥¤¥ë¤Ê¤É¤ÎÊ¸»úÎó
#½ÐÎÏ  ¡§¥³¥ó¥È¥í¡¼¥ë¥³¡¼¥É(¿§¾ðÊó)¤¬¤Ä¤¤¤¿Ê¸»úÎó
#
############################################################


ColoringStream(){
    sed \
	-e "s@\("$_HOSTNAME"\)@[34;47;1m\1[0m@g" \
	-e 's@\([Oo][Nn][Ll][Ii][Nn][Ee]\)@[33m\1[0m@g' \
	-e "s@\($GDATE1\)@[35;1m\1[0m@g" \
	-e "s@\($GDATE0\)@[35;1m\1[0m@g" \
	-e 's@\(mach_kernel\)@[33m\1[0m@g' \
	-e 's@\([Ee][Rr][Rr][Oo][Rr]\)@[31;40;1m\1[0m@g' \
	-e 's@\([Cc][Rr][Aa][Ss][Hh]\)@[31;40;1m\1[0m@g' \
	-e 's@\([Ff][Aa][Ii][Ll]\)@[33;40;1m\1[0m@g' \
	-e 's@\([Ww][Aa][Rr][Nn][Ii][Nn][Gg]\)@[33;40;1m\1[0m@g' \
	-e 's@\([Ff][Aa][Tt][Aa][Ll]\)@[31;40;1m\1[0m@g' \
	-e 's@\([Oo][Ff][Ff][Ll][Ii][Nn][Ee]\)@[31;40;1m\1[0m@g' \
	$1
}
############################################################
#´Ø¿ôÌ¾¡§CheckProcess
#µ¡Ç½  ¡§¥×¥í¥»¥¹¤Î¥Á¥§¥Ã¥¯
#ÆþÎÏ  ¡§$PROCESSÊÑ¿ô¤Ë½ñ¤«¤ì¤¿¥×¥í¥»¥¹¤Î¥ê¥¹¥È
#½ÐÎÏ  ¡§¥×¥í¥»¥¹¤¬Â¸ºß¤¹¤ë¤«¤É¤¦¤«¤ò½ÐÎÏ
#
############################################################
CheckProcess(){

    for ProcessList in `echo ${PROCESS}`
    do
      ${ECHO}  "### Process check ( ${NOR}${ProcessList}${END} ) ###"
      read ans
      ${PS} | 
      grep -v grep | 
      grep ${ProcessList} 
      read ans
    done
}

############################################################
#´Ø¿ôÌ¾¡§CheckSyslog
#µ¡Ç½  ¡§¥í¥°¤Î¥Á¥§¥Ã¥¯¡£
#ÆþÎÏ  ¡§$LogListÊÑ¿ô¤Ë½ñ¤«¤ì¤¿¥í¥°¤Î¥ê¥¹¥È
#½ÐÎÏ  ¡§¥í¥°(Syslog·Á¼°¡£ÆüÉÕ¤¬Æþ¤Ã¤Æ¤¤¤ë¤â¤Î)¤ò¥Ú¡¼¥¸¥ã¤Ç¸«¤ë
#
############################################################
CheckSyslog(){
    for LogList in `echo ${SYSLOG}`
    do
      LogList=`echo ${LogList} | sed -e "s/YYMMDD/${YY}${MM}${DD}/"`
      LogList=`echo ${LogList} | sed -e "s/YYYYMMDD/${YYYY}${MM}${DD}/"`
      FILETYPE=`basename ${LogList}`
	  
      ${ECHO}  "### Log check ( ${NOR}${LogList}${END} ) ###"
      read ans

      if [ ${COLOR} = "YES" ]
      then
	  case ${FILETYPE} in
 	      *.gz)
 	          ${SUDO} zcat ${LogList} | Ignoring | 
		  egrep "${GREPDATE}" | ColoringStream | 
		  ${PAGER} 
 		  ;;
 	      *) 
   	          ${SUDO} egrep "${GREPDATE}" ${LogList}  | Ignoring |
		  ColoringStream |
		  ${PAGER} 
 		  ;;
 	  esac
      else
	  case ${FILETYPE} in
 	      *.gz)
 	          ${SUDO} zcat ${LogList} | Ignoring | 
		  egrep "${GREPDATE}" |
		  ${PAGER} 
 		  ;;
 	      *) 
   	          ${SUDO} egrep "${GREPDATE}" ${LogList}  | Ignoring |
		  ${PAGER} 
 		  ;;
 	  esac
      fi
#        if [ "${PAGER}" = "less" -o "${PAGER}" = "jless" -a ${LESSVERSION} -gt 340 ] 
#        then
# 	  case ${FILETYPE} in
#  	      *.gz)
#  	          ${SUDO} zcat ${LogList} | Ignoring | 
# 		  egrep "${GREPDATE}" | ColoringStream | 
# 		  ${PAGER} 
#  		  ;;
#  	      *) 
#    	          ${SUDO} egrep "${GREPDATE}" ${LogList}  | Ignoring |
# 		  ColoringStream |
# 		  ${PAGER} 
#  		  ;;
#  	  esac
#        else
#   	  case ${FILETYPE} in
#   	      *.gz) 
#   		  ${SUDO} zcat ${LogList} | Ignoring |
#  		  egrep "${GREPDATE}"  |  
#  		  ${PAGER} 
#   		  ;;
#   	      *) 
#                    ${SUDO} egrep "${GREPDATE}" ${LogList} | Ignoring|
#  		  ${PAGER} 
#   		  ;;
#   	  esac
#         fi

#      ${ECHO}  "#--- The check of a ${NOR}${LogList}${END} finished ---#" 
      read ans
    done
}

############################################################
#´Ø¿ôÌ¾¡§CheckLog
#µ¡Ç½  ¡§¥í¥°¤Î¥Á¥§¥Ã¥¯¡£
#ÆþÎÏ  ¡§$LogListÊÑ¿ô¤Ë½ñ¤«¤ì¤¿¥í¥°¤Î¥ê¥¹¥È
#½ÐÎÏ  ¡§¥í¥°(À¸¤Î¥í¥°¡£ÆüÉÕ¤Ê¤É¤¬Æþ¤Ã¤Æ¤¤¤Ê¤¤¤â¤Î)¤ò¥Ú¡¼¥¸¥ã¤Ç¸«¤ë
#
############################################################
CheckLog(){
    for LogList in `echo ${LOG}`
    do
      LogList=`echo ${LogList} | sed -e "s/YYMMDD/${YY}${MM}${DD}/"`
      LogList=`echo ${LogList} | sed -e "s/YYYYMMDD/${YYYY}${MM}${DD}/"`
      FILETYPE=`basename ${LogList}`
	  
      ${ECHO}  "### Log check ( ${NOR}${LogList}${END} ) ###"
      read ans

      if [ ${COLOR} = "YES" ]
      then
	  case ${FILETYPE} in
 	      *.gz)
 	          ${SUDO} zcat ${LogList} | Ignoring | 
		  ColoringStream | 
		  ${PAGER} 
 		  ;;
 	      *) 
   	          ${SUDO} cat ${LogList}  | Ignoring |
		  ColoringStream |
		  ${PAGER} 
 		  ;;
 	  esac
       else
 	  case ${FILETYPE} in
 	      *.gz) 
 		  ${SUDO} zcat ${LogList} | Ignoring  |
		  ${PAGER} 
 		  ;;
 	      *) 
                  ${SUDO} cat ${LogList} | Ignoring|
		  ${PAGER} 
 		  ;;
 	  esac
       fi

#      ${ECHO}  "#--- The check of a ${NOR}${LogList}${END} finished ---#" 
      read ans
    done
}

############################################################
#´Ø¿ôÌ¾¡§CheckBackup
#µ¡Ç½  ¡§¥Ð¥Ã¥¯¥¢¥Ã¥×¤Î¥Á¥§¥Ã¥¯¡£
#ÆþÎÏ  ¡§$LogListÊÑ¿ô¤Ë½ñ¤«¤ì¤¿¥í¥°¤Î¥ê¥¹¥È
#½ÐÎÏ  ¡§¥í¥°¤«¤é $BackupWord ¤Ç»ØÄê¤µ¤ì¤¿¤â¤Î¤ò grep ¤·¤Æ
#        ¥Ú¡¼¥¸¥ã¤Ç¸«¤ë
#
############################################################
CheckBackup(){
    for LogList in `echo ${BACKUPLOG}`
    do
      LogList=`echo ${LogList} | sed -e "s/YYMMDD/${YY}${MM}${DD}/"`
      LogList=`echo ${LogList} | sed -e "s/YYYYMMDD/${YYYY}${MM}${DD}/"`
      FILETYPE=`basename ${LogList}`
          
      ${ECHO}  "### Backup check ( ${NOR}${LogList}${END} ) ###"
      read ans

      if [ ${COLOR} = "YES" ]
      then
          case ${FILETYPE} in
              *.gz)
                  ${SUDO} zcat ${LogList} | egrep "${GREPDATE}" | 
		  grep ${BackupWord} | ColoringStream |
		  ${PAGER} 
                  ;;
              *) 
                  ${SUDO} cat ${LogList}  | egrep "${GREPDATE}" | 
		  grep ${BackupWord} | ColoringStream | 
		  ${PAGER} 
                  ;;
          esac
       else
          case ${FILETYPE} in
              *.gz) 
                  ${SUDO} zcat ${LogList} | egrep "${GREPDATE}" | 
		  grep ${BackupWord} | 
		  ${PAGER} 
                  ;;
              *) 
                  ${SUDO} cat ${LogList} | egrep "${GREPDATE}" | 
		  grep ${BackupWord} | 
		  ${PAGER} 
                  ;;
          esac
       fi

#      ${ECHO}  "#--- The  Backup check of a ${NOR}${LogList}${END} finished ---
      read ans
    done
}





############################################################
#´Ø¿ôÌ¾¡§CheckEtc
#µ¡Ç½  ¡§¼ç¤Ë/etcÇÛ²¼¤Î¥Õ¥¡¥¤¥ë¤Î¹¹¿·³ÎÇ§
#ÆþÎÏ  ¡§ETCHECKÊÑ¿ô¤è¤êÅÏ¤µ¤ì¤ë¥Æ¥­¥¹¥È¥Õ¥¡¥¤¥ë¡£
#½ÐÎÏ  ¡§¥í¡¼¥«¥ë¤Ë¤â¤Ã¤Æ¤¤¤ë¥Æ¥­¥¹¥È¥Õ¥¡¥¤¥ë¤È¤Îdiff,¤ª¤è¤Ó
#       ¹¹¿·³ÎÇ§¸å¤Î¥í¡¼¥«¥ë¥Õ¥¡¥¤¥ë¤Î¹¹¿·(²¿¤¤¤Ã¤Æ¤ë¤«ÉÔÌÀ)
#
############################################################
CheckEtc(){
    for c in `echo ${ETCHECK}`
    do
      FNAME=`basename $c`
      if [ ! -f ${HOME}/bin/.${FNAME}.1 ]
      then
	  cp ${c} ${HOME}/bin/.${FNAME}.1
      fi

      ${ECHO}  "###--- The check of a  ${NOR}${c}${END} ---###"
      diff -u1 ${HOME}/bin/.${FNAME}.1 $c
      if [ $? -ne 0 ]
      then
	  echo "##### $c Update OK? (y/n)#####"
	  read YN
	  case $YN in
	      y)  i=7
		  while [ $i -gt 1 ]
		  do
		    h=`expr $i - 1`
		    if [ -f ${HOME}/bin/.${FNAME}.${h} ]
		    then
			mv ${HOME}/bin/.${FNAME}.${h} ${HOME}/bin/.${FNAME}.${i}
		    fi
		    i=`expr $i - 1`
		  done
		  cp ${c} ${HOME}/bin/.${FNAME}.1
		  echo "${c} was updated"
		  ;;
	      n)  echo "${c} wasn't updated"
		  ;;
	      *)  echo "Please Answer y or n. Exit."
		  exit 1
		  ;;
	  esac
	      
      else
	  echo "###--- $c was Unchanged. Please Enter ---###"
	  read ans
      fi
    done
}

############################################################
#´Ø¿ôÌ¾¡§TapeCheck
#µ¡Ç½  ¡§¥Æ¡¼¥×¤¬¥»¥Ã¥È¤µ¤ì¤Æ¤¤¤ë¤«¤É¤¦¤«¤ò¥Á¥§¥Ã¥¯¡£
#ÆþÎÏ  ¡§.ck¤Ë TAPE='/dev/nst0'¤Î¤è¤¦¤Ëµ­½Ò¡£ÊÑ¿ô¤¬Â¸ºß¤·¤Ê¤¤¾ì¹ç¤Ï
#       ¡¡¥Á¥§¥Ã¥¯¼«ÂÎ¤ò¹Ô¤ï¤Ê¤¤¡¡¡¡¡¡¡¡
#½ÐÎÏ  ¡§Àµ¾ï¤Ë¥Þ¥¦¥ó¥È¤µ¤ì¤Æ¤¤¤ë¤«¤É¤¦¤«¤À¤±¡¢¿§ÉÕ¤­
#¡¡¡¡¡¡¡¡¤ÇÉ½¼¨¤¹¤ë¡£
############################################################
TapeCheck(){

echo "##### Tape Device Check #####"
echo "Please hit ENTER to continue."

        read ans
        ${SUDO} mt -f ${TAPE} status | grep ONLINE >/dev/null 2>&1 
        if [ $? -eq 0 ]; then
                echo 'Tape is Online' | ColoringStream 
                exit 0
        else
	        echo 'Tape is Offline' | ColoringStream 
        fi
echo
}




### Main ###
SUDO=${SUDO:="NO"}
if [ ${SUDO} = "yes" ]
then
    UsingSudo
else
    SUDO=""
fi 

CheckProcess
CheckSyslog
CheckLog
CheckEtc
CheckBackup

TAPE=${TAPE:="NO"}
if [ ${TAPE} != "NO" ]
then
    TapeCheck
fi 


# memo
#
#   customer 		os
#   ------------------------------------------------------------
#   Comware(orange)	SunOS -5
#   ebara(ebrbs301)	SunOS -5
#   eplace(eplace)	FreeBSD
#   titech              FreeBSD
#   sendai1             Linux

# head	1.2;
# access;
# symbols;
# locks
# 	kakikubo:1.2; strict;
# comment	@# @;


# 1.2
# date	2002.10.25.12.52.20;	author kakikubo;	state Exp;
# branches;
# next	1.1;

# 1.1
# date	2002.10.25.12.32.37;	author kakikubo;	state Exp;
# branches;
# next	;


# desc
# @Start RCS
# @


# 1.2
# log
# @print color success
# @
# text
# @#!/bin/sh
# #
# # colorcal.sh
# #    cal¥³¥Þ¥ó¥É¤Î½ÐÎÏ·ë²Ì¤ò¿§¤ò¤Ä¤±¤ÆÉ½¼¨¤¹¤ë¥×¥í¥°¥é¥à
# #    Æü·ÐLinux2002Ç¯7·î¹æ ¤è¤ê

# # (Æ¦ÃÎ¼±)¥¨¥¹¥±¡¼¥×¥·¡¼¥±¥ó¥¹¤Î½ñ¼°¤Ï¼¡¤ÎÄÌ¤ê


# # ¥¨¥¹¥±¡¼¥×¥·¡¼¥±¥ó¥¹¤òÍøÍÑ¤·¤¿Îã
# #
# #  ¡ØESC[3x;4y;zm¡Ù
# #    
# #  ²òÀâ
# #  x -> Ê¸»ú¿§¡£0¡Á7¤Þ¤Ç¤Î¿ô»ú¤ò»ØÄê¤Ç¤­¤ë(°Ê²¼»²¾È)¡£
# #  y -> ÇØ·Ê¿§¡£0¡Á7¤Þ¤Ç¤Î¿ô»ú¤ò»ØÄê¤Ç¤­¤ë(°Ê²¼»²¾È)¡£
# #  z -> ¥Ü¡¼¥ë¥ÉÊ¸»ú¤ÎON¡¿OFF¤ò»ØÄê¤¹¤ë¡£1¤¬ON¡£¤Ê¤±¤ì¤ÐOFF¡£
# #  ¡Ø¿ô»ú¤È¿§¤ÎÂÐ±þÉ½¡Ù
# #  0 ¹õ
# #  1 ÀÖ
# #  2 ÎÐ
# #  3 ²«¡¿Ãã
# #  4 ÀÄ
# #  5 ¥Þ¥¼¥ó¥¿
# #  6 ¥·¥¢¥ó
# #  7 Çò¡¿³¥

# #  °Ê²¼¤ò¼Â¹Ô¤¹¤ì¤Ð¤è¤¯¤ï¤«¤ë¡£
# #  ¡Ø-e¡Ù¤Ï¥¨¥¹¥±¡¼¥×¥·¡¼¥±¥ó¥¹¤òÍ­¸ú¤Ë¤¹¤ë°Ù¤Î¥ª¥×¥·¥ç¥ó
# #
# #  echo -e "\033[31;40;1m¹õÃÏ¤ËÀÖ¤¤Ê¸»ú\033[37;40;m"

# #¥¨¥¹¥±¡¼¥×¥·¡¼¥±¥ó¥¹
# ESC="\033["

# #¹õÃÏ¤ËÀÖÊ¸»ú
# PRE="31;40;1m"

# #¹õÃÏ¤ËÇòÊ¸»ú
# POST="37;40;m"

# # ÆüÉÕ¤ò¼èÆÀ¤¹¤ë(É¬¤º2·å)
# #TODAY=`date '+%-d'` ###LinuxÍÑ
# TODAY=`date '+%d'`   ###FreeBSDÍÑ
# #echo ${TODAY}

# BEFORE=`cal | grep -w ${TODAY} | sed -e "s/\(.*\)${TODAY}.*/\1/g"`
# AFTER=`cal  | grep -w ${TODAY} | sed -e "s/.*${TODAY}\(.*\)/\1/g"`

# echo TODAY: ${TODAY}
# echo before: ${BEFORE}
# echo after: ${AFTER}
# echo 

# echo -e "${BEFORE}${ESC}${PRE}${TODAY}${ESC}${POST}${AFTER}"

# @


# 1.1
# log
# @Initial revision
# @
# text
# @d37 1
# a37 1
# PRE="31;40;m"
# d45 1
# a45 1
# echo ${TODAY}
# d47 9
# a55 1
# cal | sed -e "s/${TODAY}/${ESC}${PRE}${TODAY}${ESC}${POST}/g"
# @

# date¥³¥Þ¥ó¥É¤Î»²¹ÍURL
# http://x68000.startshop.co.jp/~68user/unix/pickup?date/
# ¤·¤é¤Ù¤¿¤È¤³¤í¡¢
# env TZ=JST+167 (9+167 / 24 = 7.333...)¤Ä¤Þ¤ê1½µ´ÖÁ°¤Þ¤Ç¤Ï
# ÆüÉÕ¤ò¼èÆÀ¤¹¤ë»ö¤¬¤Ç¤­¤ë¡£
# ¤¿¤À¡¢¤«¤ó¤¬¤¨¤ì¤Ð¹Í¤¨¤ëÄø¤Ê¤ó¤«ÊÑ¤À¤Ê¡Ä¤³¤ÎÆ°¤­¤Ï¡£
# ¤³¤ì¤Ã¤Æ"JST+167"¤ò"9+167"¤È²ò¼á¤·¤Æ¤¤¤ë¤ï¤±¤Ç¤Ï¤Ê¤¤¤é¤·¤¤¡£
