#! /bin/sh

# $Id$
# ck
#
# configlation file is ~/bin/ck.conf
#
#

############################################################
# $B%Q%9$N;XDj!#@_Dj%U%!%$%k$NFI$_9~$_!#(BLANG$B$O(BC$B$r;HMQ(B
############################################################
PATH="/usr/local/bin/:/usr/bin:/bin"
. ./ck.conf
LANG=C
_HOSTNAME=`hostname | sed 's/\..*//'`

export PATH LANG

############################################################
#$B%Z!<%8%c$,;XDj$5$l$F$$$k$+$I$&$+$N%A%'%C%/(B
#$B;XDj$5$l$F$$$J$$>l9g$O(Bmore$B$r;HMQ(B
############################################################
# if [ "${PAGER}x" = "x" ]
# then
#     PAGER=more
#     export $PAGER
# fi
PAGER=${PAGER:=more}

############################################################
#$B%+%i!<%j%s%0$r9T$&%W%m%0%i%`(B(perl)$B$,%$%s%9%H!<%k$5$l$F$$$l$P(B
#$B$=$l$r;HMQ$9$k(B
############################################################
if [ -f ${HOME}/bin/logcolorise.pl ]
then
    COLORISE="${HOME}/bin/logcolorise.pl"
    COLORMODE=ON
    export COLORISE COLORMODE
fi

############################################################
#$B%W%m%;%9%A%'%C%/$K;HMQ$9$k%+%i!<$rDj5A(B
############################################################
NOR="\033[32;40;1m"
ERR="\033[31;40;1m"
END="\033[37;40;m"



############################################################
#$B4X?tL>!'(BOstype
#$B5!G=(B  $B!'%W%m%0%i%`$r<B9T$9$k%[%9%H$N(BOS$B$rH=JL$9$k!#(B
#$BF~NO(B  $B!'$J$7(B
#$B=PNO(B  $B!'(BOS$B$N<oN`(B
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
#$B4X?tL>!'$J$7(B
#$B5!G=(B  $B!'(BOS$B$K$h$C$F;HMQ$9$k%3%^%s%I$rH=JL(B
############################################################
WHATOS=`Ostype`
case "${WHATOS}" in
	LINUX) PS='/bin/ps -ax'
			ECHO='echo -e'
			break
			;;
	FREEBSD) PS='/bin/ps -ax'
			ECHO='echo -e'
			break
			;;
	SOLARIS)PS='/bin/ps -ef'
			ECHO='echo'
			break
			;;
	*)		PS='/bin/ps -auxwww'
			;;
esac
case "${WHATOS}" in
	LINUX) PS='/bin/ps -ax'
			ECHO='echo -e'
			break
			;;
	FREEBSD|MacOSX) PS='/bin/ps -ax'
			ECHO='echo -e'
			break
			;;
	SOLARIS)PS='/bin/ps -ef'
			ECHO='echo'
			break
			;;
	*)		PS='/bin/ps -auxwww'			ECHO='echo'
			ECHO='echo'
			;;
esac


############################################################
#$B4X?tL>!'$J$7(B
#$B5!G=(B  $B!'%m%0%U%!%$%k$+$i3:EvF|IU$N$_$r%T%C%/%"%C%W!#(B
#       ck$B%3%^%s%I<+BN$K(B-[1-7]$B$r;XDj$G$-$k!#%G%U%)%k%H$O(B1$B$G!"(B
#       $BEvF|!"A0F|$r8+$k!#(B-7$B$,;XDj$5$l$?>l9g$OEvF|$+$i(B7$BF|A0$^$G(B
#       $B%T%C%/%"%C%W$7$F8+$k!#(B
#
############################################################
YYYY=`date +'%Y'`
YY=`date +'%y'`
MM=`date +'%m'`
DD=`date +'%d'`
# GDATE7=`date -v -7d +'%b %e'`
# GDATE6=`date -v -6d +'%b %e'`
# GDATE5=`date -v -5d +'%b %e'`
# GDATE4=`date -v -4d +'%b %e'`
# GDATE3=`date -v -3d +'%b %e'`
# GDATE2=`date -v -2d +'%b %e'`
# GDATE1=`date -v -1d +'%b %e'`
# GDATE0=`date -v -0d +'%b %e'`
# OPT=
# GREPDATE="${GDATE1}|${GDATE0}"
# export GREPDATE

# while getopts 1234567n OPT
# do
#   case $OPT in
#       7)  GREPDATE="${GDATE7}|${GDATE6}|${GDATE5}|${GDATE4}|${GDATE3}|${GDATE2}|${GDATE1}|${GDATE0}"
# 	  ;;
#       6)  GREPDATE="${GDATE6}|${GDATE5}|${GDATE4}|${GDATE3}|${GDATE2}|${GDATE1}|${GDATE0}"
# 	  ;;
#       5)  GREPDATE="${GDATE5}|${GDATE4}|${GDATE3}|${GDATE2}|${GDATE1}|${GDATE0}"
# 	  ;;
#       4)  GREPDATE="${GDATE4}|${GDATE3}|${GDATE2}|${GDATE1}|${GDATE0}"
# 	  ;;
#       3)  GREPDATE="${GDATE3}|${GDATE2}|${GDATE1}|${GDATE0}"
# 	  ;;
#       2)  GREPDATE="${GDATE2}|${GDATE1}|${GDATE0}"
# 	  ;;
#       1)  GREPDATE="${GDATE1}|${GDATE0}"
# 	  ;;
#       n)  COLORMODE=OFF
# 	  ;;
#       \?) echo "Usage: $0 [-1234567]" 1>&2 
#           exit 1   
#           ;;
#   esac
# done

shift `expr $OPTIND - 1`

############################################################
#$B4X?tL>!'(BCheckProcess
#$B5!G=(B  $B!'%W%m%;%9$N%A%'%C%/(B
#$BF~NO(B  $B!'(B$PROCESS$BJQ?t$K=q$+$l$?%W%m%;%9$N%j%9%H(B
#$B=PNO(B  $B!'%W%m%;%9$,B8:_$9$k$+$I$&$+$r=PNO(B
#
############################################################
CheckProcess(){

    for ProcessList in `echo ${PROCESS}`
    do
      ${ECHO}  "### Process check ( ${NOR}${ProcessList}${END} ) ###"
      read ans
      ${PS} | grep -v grep | grep ${ProcessList} | ${PAGER}
      ${ECHO}  "#--- The check of a ${NOR}${ProcessList}${END} finished ---#" 
      read ans
    done
}
############################################################
#$B4X?tL>!'(B ColoringStream
#$B5!G=(B  $B!'I8=`F~NO$+$i<u$1$?%G!<%?$r0lDj5,B'$G?'IU$1$7$F=PNO$9$k(B
#$BF~NO(B  $B!'%m%0%U%!%$%k$J$I$NJ8;zNs(B
#$B=PNO(B  $B!'%3%s%H%m!<%k%3!<%I(B($B?'>pJs(B)$B$,$D$$$?J8;zNs(B
#
############################################################

ColoringStream(){
    sed \
	-e "s@\("$_HOSTNAME"\)@[34m\1[0m@g" \
	-e 's@\(mach_kernel\)@[33m\1[0m@g' \
	-e 's@\([Ee][Rr][Rr][Oo][Rr]\)@[31;40;1m\1[0m@g' \
	-e 's@\([Ff][Aa][Ii][Ll]\)@[31;40;1m\1[0m@g' \
	$1
}

############################################################
#$B4X?tL>!'(BCheckLog
#$B5!G=(B  $B!'%m%0$N%A%'%C%/!#(Bperl$B$,%$%s%9%H!<%k$5$l$F$$$F(BPAGER$B$K(Bless$B$,(B
#       $B;XDj$5$l$F$$$k>l9g$O%m%0$r%+%i!<$GI=<(!#(B
#$BF~NO(B  $B!'(B$LogList$BJQ?t$K=q$+$l$?%m%0$N%j%9%H(B
#$B=PNO(B  $B!'%m%0$r%Z!<%8%c$G8+$k(B
#
############################################################
CheckLog(){
    for LogList in `echo ${LOG}`
    do
      LogList=`echo ${LogList} | sed -e "s/YYMMDD/${YY}${MM}${DD}/"`
      LogList=`echo ${LogList} | sed -e "s/YYYYMMDD/${YYYY}${MM}${DD}/"`
	  
      ${ECHO}  "### Log check ( ${NOR}${LogList}${END} ) ###"
      read ans


      if [ "${WHATOS}" = "FREEBSD" -a "${COLORMODE}" = "ON" ]
      then 
	  case $LogList in
	      *.gz) 
	          zcat ${LogList} | ${COLORISE}  | egrep "${GREPDATE}" | ${PAGER} -R
		  ;;
	      *) 
  	          ${COLORISE} ${LogList} | egrep "${GREPDATE}" | ${PAGER} -R
		  ;;
	  esac
      else
	  case $LogList in
	      *.gz) 
		  zcat ${LogList} | egrep "${GREPDATE}"  | ${PAGER} 
		  ;;
	      *) 
                  egrep "${GREPDATE}" ${LogList} | ColoringStream | ${PAGER} -R
		  ;;
	  esac
      fi
      ${ECHO}  "#--- The check of a ${NOR}${LogList}${END} finished ---#" 
      read ans
    done
}




############################################################
#$B4X?tL>!'(BCheckEtc
#$B5!G=(B  $B!'<g$K(B/etc$BG[2<$N%U%!%$%k$N99?73NG'(B
#$BF~NO(B  $B!'(BETCHECK$BJQ?t$h$jEO$5$l$k%F%-%9%H%U%!%$%k!#(B
#$B=PNO(B  $B!'%m!<%+%k$K$b$C$F$$$k%F%-%9%H%U%!%$%k$H$N(Bdiff,$B$*$h$S(B
#       $B99?73NG'8e$N%m!<%+%k%U%!%$%k$N99?7(B($B2?$$$C$F$k$+ITL@(B)
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
	  read a
      fi
    done
}

#CheckProcess
CheckLog
#CheckEtc


### Check the /etc/hogehoge
###  $B$3$3$O$^$?$D$/$k$3$H$K$9$k$+!D(B
# CheckEtc(){
#     for ETC in `echo ${CHECKETC}`
#     do
#       ls -1tr ${ETC}
#       diff -u1 ${ETC} ${HOME}/.ck/
#     done
# }
  
# IG="("

# for I in `echo ${IGNRULE}`
# do
#   for l in `echo $LOG`
#     do
#     if [ $l = $I ] 
#     then
#       echo $I'$B$O%m%0%U%!%$%k(B'
#       break
#     else
#       echo $I'$B$OL5;k$9$kJ8;zNs(B'
#       IG=${IG}$I"|"
#       break
#     fi
#   done
# done
# IG="${IG}grep)"
# echo '$BL5;k$9$k$b$8$l$DAm9g(B'$IG
# #exit



#  Search the Os type Function
#
# `uname -s`$B%3%^%s%I$N7k2L$K$h$C$F%3%^%s%I(B(ps$B$J$I(B)$B$rJ,4t=hM}$5$;$l$P(B
# $BHFMQ@-$,A}$9$N$G$O!)(B


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
# #    cal$B%3%^%s%I$N=PNO7k2L$r?'$r$D$1$FI=<($9$k%W%m%0%i%`(B
# #    $BF|7P(BLinux2002$BG/(B7$B7n9f(B $B$h$j(B

# # ($BF&CN<1(B)$B%(%9%1!<%W%7!<%1%s%9$N=q<0$O<!$NDL$j(B


# # $B%(%9%1!<%W%7!<%1%s%9$rMxMQ$7$?Nc(B
# #
# #  $B!X(BESC[3x;4y;zm$B!Y(B
# #    
# #  $B2r@b(B
# #  x -> $BJ8;z?'!#(B0$B!A(B7$B$^$G$N?t;z$r;XDj$G$-$k(B($B0J2<;2>H(B)$B!#(B
# #  y -> $BGX7J?'!#(B0$B!A(B7$B$^$G$N?t;z$r;XDj$G$-$k(B($B0J2<;2>H(B)$B!#(B
# #  z -> $B%\!<%k%IJ8;z$N(BON$B!?(BOFF$B$r;XDj$9$k!#(B1$B$,(BON$B!#$J$1$l$P(BOFF$B!#(B
# #  $B!X?t;z$H?'$NBP1~I=!Y(B
# #  0 $B9u(B
# #  1 $B@V(B
# #  2 $BNP(B
# #  3 $B2+!?Cc(B
# #  4 $B@D(B
# #  5 $B%^%<%s%?(B
# #  6 $B%7%"%s(B
# #  7 $BGr!?3%(B

# #  $B0J2<$r<B9T$9$l$P$h$/$o$+$k!#(B
# #  $B!X(B-e$B!Y$O%(%9%1!<%W%7!<%1%s%9$rM-8z$K$9$k0Y$N%*%W%7%g%s(B
# #
# #  echo -e "\033[31;40;1m$B9uCO$K@V$$J8;z(B\033[37;40;m"

# #$B%(%9%1!<%W%7!<%1%s%9(B
# ESC="\033["

# #$B9uCO$K@VJ8;z(B
# PRE="31;40;1m"

# #$B9uCO$KGrJ8;z(B
# POST="37;40;m"

# # $BF|IU$r<hF@$9$k(B($BI,$:(B2$B7e(B)
# #TODAY=`date '+%-d'` ###Linux$BMQ(B
# TODAY=`date '+%d'`   ###FreeBSD$BMQ(B
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
