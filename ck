#! /bin/sh

# $Id$
# ck
#
# configlation file is ~/.ck



############################################################
# �ѥ��λ��ꡣ����ե�������ɤ߹��ߡ�LANG��C�����
############################################################
PATH="/usr/local/bin/:/usr/bin:/bin" ; export PATH
. ${HOME}/.ck
#LANG=C
_HOSTNAME=`hostname | sed 's/\..*//'`


############################################################
# �ڡ����㤬���ꤵ��Ƥ��뤫�ɤ����Υ����å�
# ���ꤵ��Ƥ��ʤ�����more�����
# PAGER��less�����ꤵ��Ƥ������ǳ�ġ������������358�ʹߤ�
# ����Х��顼��󥰤�ͭ���Ȥʤ롣
############################################################
PAGER=${PAGER:=more} ; export PAGER
#LESS=${LESS:="-E"}  ; export����ϴ��� 
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
# sudo����Ѥ���٤δؿ������
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
#�ץ��������å��˻��Ѥ��륫�顼�����(process color)
############################################################
NOR="\033[34;1m"
ERR="\033[31;40;1m"
END="\033[30;m"



############################################################
#�ؿ�̾��Ostype
#��ǽ  ���ץ�����¹Ԥ���ۥ��Ȥ�OS��Ƚ�̤��롣
#����  ���ʤ�
#����  ��OS�μ���
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
#�ؿ�̾���ʤ�
#��ǽ  ��OS�ˤ�äƻ��Ѥ��륳�ޥ�ɤ�Ƚ��
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
#�ؿ�̾���ʤ�
#��ǽ  �����ե����뤫�鳺�����դΤߤ�ԥå����åס�
#       ck���ޥ�ɼ��Τ�-[1-7]�����Ǥ��롣�ǥե���Ȥ�1�ǡ�
#       �����������򸫤롣-7�����ꤵ�줿������������7�����ޤ�
#       �ԥå����åפ��Ƹ��롣
#
#        ���ߤ�����ʬ�Ⱥ���ʬ�Τߤ���Ϥ���褦���ѹ�����Ƥ��롣
############################################################

# +,-��ɬ��ɽ������ˤϤ�������Τ���
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
#�ؿ�̾�� Ignoring
#��ǽ  ��ɸ�����Ϥ���������ǡ�����ʤ�
#����  �����ե�����ʤɤ�ʸ����
#����  ���ѥ�����ˤҤä�����ʤ��ä���ΰʳ��ι�
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
#�ؿ�̾�� ColoringStream
#��ǽ  ��ɸ�����Ϥ���������ǡ�������구§�ǿ��դ����ƽ��Ϥ���
#����  �����ե�����ʤɤ�ʸ����
#����  ������ȥ��륳����(������)���Ĥ���ʸ����
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
#�ؿ�̾��CheckProcess
#��ǽ  ���ץ����Υ����å�
#����  ��$PROCESS�ѿ��˽񤫤줿�ץ����Υꥹ��
#����  ���ץ�����¸�ߤ��뤫�ɤ��������
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
#�ؿ�̾��CheckSyslog
#��ǽ  �����Υ����å���
#����  ��$LogList�ѿ��˽񤫤줿���Υꥹ��
#����  ����(Syslog���������դ����äƤ�����)��ڡ�����Ǹ���
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
#�ؿ�̾��CheckLog
#��ǽ  �����Υ����å���
#����  ��$LogList�ѿ��˽񤫤줿���Υꥹ��
#����  ����(���Υ������դʤɤ����äƤ��ʤ����)��ڡ�����Ǹ���
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
#�ؿ�̾��CheckBackup
#��ǽ  ���Хå����åפΥ����å���
#����  ��$LogList�ѿ��˽񤫤줿���Υꥹ��
#����  �������� $BackupWord �ǻ��ꤵ�줿��Τ� grep ����
#        �ڡ�����Ǹ���
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
#�ؿ�̾��CheckEtc
#��ǽ  �����/etc�۲��Υե�����ι�����ǧ
#����  ��ETCHECK�ѿ�����Ϥ����ƥ����ȥե����롣
#����  ��������ˤ�äƤ���ƥ����ȥե�����Ȥ�diff,�����
#       ������ǧ��Υ�����ե�����ι���(�����äƤ뤫����)
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
#�ؿ�̾��TapeCheck
#��ǽ  ���ơ��פ����åȤ���Ƥ��뤫�ɤ���������å���
#����  ��.ck�� TAPE='/dev/nst0'�Τ褦�˵��ҡ��ѿ���¸�ߤ��ʤ�����
#       �������å����Τ�Ԥ�ʤ���������
#����  ������˥ޥ���Ȥ���Ƥ��뤫�ɤ������������դ�
#����������ɽ�����롣
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
# #    cal���ޥ�ɤν��Ϸ�̤򿧤�Ĥ���ɽ������ץ����
# #    ����Linux2002ǯ7��� ���

# # (Ʀ�μ�)���������ץ������󥹤ν񼰤ϼ����̤�


# # ���������ץ������󥹤����Ѥ�����
# #
# #  ��ESC[3x;4y;zm��
# #    
# #  ����
# #  x -> ʸ������0��7�ޤǤο��������Ǥ���(�ʲ�����)��
# #  y -> �طʿ���0��7�ޤǤο��������Ǥ���(�ʲ�����)��
# #  z -> �ܡ����ʸ����ON��OFF����ꤹ�롣1��ON���ʤ����OFF��
# #  �ؿ����ȿ����б�ɽ��
# #  0 ��
# #  1 ��
# #  2 ��
# #  3 ������
# #  4 ��
# #  5 �ޥ���
# #  6 ������
# #  7 �򡿳�

# #  �ʲ���¹Ԥ���Ф褯�狼�롣
# #  ��-e�٤ϥ��������ץ������󥹤�ͭ���ˤ���٤Υ��ץ����
# #
# #  echo -e "\033[31;40;1m���Ϥ��֤�ʸ��\033[37;40;m"

# #���������ץ�������
# ESC="\033["

# #���Ϥ���ʸ��
# PRE="31;40;1m"

# #���Ϥ���ʸ��
# POST="37;40;m"

# # ���դ��������(ɬ��2��)
# #TODAY=`date '+%-d'` ###Linux��
# TODAY=`date '+%d'`   ###FreeBSD��
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

# date���ޥ�ɤλ���URL
# http://x68000.startshop.co.jp/~68user/unix/pickup?date/
# ����٤��Ȥ���
# env TZ=JST+167 (9+167 / 24 = 7.333...)�Ĥޤ�1�������ޤǤ�
# ���դ������������Ǥ��롣
# ���������󤬤���йͤ������ʤ��Ѥ��ʡĤ���ư���ϡ�
# ����ä�"JST+167"��"9+167"�Ȳ�ᤷ�Ƥ���櫓�ǤϤʤ��餷����
