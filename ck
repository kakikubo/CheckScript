#! /bin/sh

# $Id$
# ck
#
# configlation file is ~/.ck
#
#

############################################################
# パスの指定。設定ファイルの読み込み。LANGはCを使用
############################################################
PATH="/usr/local/bin/:/usr/bin:/bin"
. ${HOME}/.ck
LANG=C
_HOSTNAME=`hostname | sed 's/\..*//'`

export PATH LANG

############################################################
# ページャが指定されているかどうかのチェック
# 指定されていない場合はmoreを使用
# PAGERにlessが設定されていた場合はカラーリングが有効となる。
# 上でLANG=Cとしているので jlessにする必要はないだろう。
# 懸念点としてはlessのバージョンまでをも見る事ができない点である。
############################################################
PAGER=${PAGER:=more}
if [ ${PAGER} = "jless" ]
then
    PAGER=less
    export PAGER
fi

############################################################
# sudoを使用する為の関数を定義
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
#プロセスチェックに使用するカラーを定義
############################################################
NOR="\033[32;40;1m"
ERR="\033[31;40;1m"
END="\033[37;40;m"



############################################################
#関数名：Ostype
#機能  ：プログラムを実行するホストのOSを判別する。
#入力  ：なし
#出力  ：OSの種類
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
#関数名：なし
#機能  ：OSによって使用するコマンドを判別
############################################################
WHATOS=`Ostype`
case "${WHATOS}" in
	FREEBSD|MacOSX|LINUX) PS='/bin/ps -ax'
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
#関数名：なし
#機能  ：ログファイルから該当日付のみをピックアップ。
#       ckコマンド自体に-[1-7]を指定できる。デフォルトは1で、
#       当日、前日を見る。-7が指定された場合は当日から7日前まで
#       ピックアップして見る。
#
#        現在は本日分と昨日分のみを出力するように変更されている。
############################################################

# +,-を必ず表記するにはこうするのだ。
# printf "%+d" "`expr 3 + 5`"
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
# GDATE0=`date +'%b %e'`
# OPT=
GDATE1=`env TZ=JST+15 date +'%b %e'`
GDATE0=`env TZ=JST-9  date +'%b %e'`
GREPDATE="${GDATE1}|${GDATE0}"
#GREPDATE="${GDATE0}"
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
#関数名： Ignoring
#機能  ：標準入力から受けたデータを省く
#入力  ：ログファイルなどの文字列
#出力  ：パターンにひっかからなかったもの以外の行
#
############################################################
Ignoring(){
    if [ "${IGNORE}x" = "x" ]
    then
	cat $1
    else
	egrep -v ${IGNORE} $1 
    fi
}


############################################################
#関数名： ColoringStream
#機能  ：標準入力から受けたデータを一定規則で色付けして出力する
#入力  ：ログファイルなどの文字列
#出力  ：コントロールコード(色情報)がついた文字列
#
############################################################


ColoringStream(){
    sed \
	-e "s@\("$_HOSTNAME"\)@[34;47;1m\1[0m@g" \
	-e "s@\($GDATE1\)@[35;1m\1[0m@g" \
	-e "s@\($GDATE0\)@[35;1m\1[0m@g" \
	-e 's@\(mach_kernel\)@[33m\1[0m@g' \
	-e 's@\([Ee][Rr][Rr][Oo][Rr]\)@[31;40;1m\1[0m@g' \
	-e 's@\([Cc][Rr][Aa][Ss][Hh]\)@[31;40;1m\1[0m@g' \
	-e 's@\([Ff][Aa][Ii][Ll]\)@[33;40;1m\1[0m@g' \
	-e 's@\([Ww][Aa][Rr][Nn][Ii][Nn][Gg]\)@[33;40;1m\1[0m@g' \
	-e 's@\([Ff][Aa][Tt][Aa][Ll]\)@[31;40;1m\1[0m@g' \
	$1
}
############################################################
#関数名：CheckProcess
#機能  ：プロセスのチェック
#入力  ：$PROCESS変数に書かれたプロセスのリスト
#出力  ：プロセスが存在するかどうかを出力
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
#関数名：CheckLog
#機能  ：ログのチェック。
#入力  ：$LogList変数に書かれたログのリスト
#出力  ：ログをページャで見る
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

      if [ "${PAGER}" = "less" -o "${PAGER}" = "jless" ] 
      then
	  case ${FILETYPE} in
 	      *.gz)
		  echo "hello1"
 	          ${SUDO} zcat ${LogList} | Ignoring | egrep "${GREPDATE}" | ColoringStream | ${PAGER} -R
 		  ;;
 	      *) 
		  echo "hello2"
   	          ${SUDO} egrep "${GREPDATE}" ${LogList}  | Ignoring |ColoringStream |${PAGER} -R
 		  ;;
 	  esac
       else
 	  case ${FILETYPE} in
 	      *.gz) 
		  echo "hello3"
 		  ${SUDO} zcat ${LogList} | Ignoring |egrep "${GREPDATE}"  |  ${PAGER} 
 		  ;;
 	      *) 
		  echo "hello4"
                  ${SUDO} egrep "${GREPDATE}" ${LogList} | Ignoring|  ${PAGER} 
 		  ;;
 	  esac
       fi

      ${ECHO}  "#--- The check of a ${NOR}${LogList}${END} finished ---#" 
      read ans
    done
}




############################################################
#関数名：CheckEtc
#機能  ：主に/etc配下のファイルの更新確認
#入力  ：ETCHECK変数より渡されるテキストファイル。
#出力  ：ローカルにもっているテキストファイルとのdiff,および
#       更新確認後のローカルファイルの更新(何いってるか不明)
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


SUDO=${SUDO:="NO"}
if [ ${SUDO} = "yes" ]
then
    UsingSudo
else
    SUDO=""
fi 
CheckProcess
CheckLog
#CheckEtc


### Check the /etc/hogehoge
###  ここはまたつくることにするか…
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
#       echo $I'はログファイル'
#       break
#     else
#       echo $I'は無視する文字列'
#       IG=${IG}$I"|"
#       break
#     fi
#   done
# done
# IG="${IG}grep)"
# echo '無視するもじれつ総合'$IG
# #exit



#  Search the Os type Function
#
# `uname -s`コマンドの結果によってコマンド(psなど)を分岐処理させれば
# 汎用性が増すのでは？


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
# #    calコマンドの出力結果を色をつけて表示するプログラム
# #    日経Linux2002年7月号 より

# # (豆知識)エスケープシーケンスの書式は次の通り


# # エスケープシーケンスを利用した例
# #
# #  『ESC[3x;4y;zm』
# #    
# #  解説
# #  x -> 文字色。0〜7までの数字を指定できる(以下参照)。
# #  y -> 背景色。0〜7までの数字を指定できる(以下参照)。
# #  z -> ボールド文字のON／OFFを指定する。1がON。なければOFF。
# #  『数字と色の対応表』
# #  0 黒
# #  1 赤
# #  2 緑
# #  3 黄／茶
# #  4 青
# #  5 マゼンタ
# #  6 シアン
# #  7 白／灰

# #  以下を実行すればよくわかる。
# #  『-e』はエスケープシーケンスを有効にする為のオプション
# #
# #  echo -e "\033[31;40;1m黒地に赤い文字\033[37;40;m"

# #エスケープシーケンス
# ESC="\033["

# #黒地に赤文字
# PRE="31;40;1m"

# #黒地に白文字
# POST="37;40;m"

# # 日付を取得する(必ず2桁)
# #TODAY=`date '+%-d'` ###Linux用
# TODAY=`date '+%d'`   ###FreeBSD用
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

# dateコマンドの参考URL
# http://x68000.startshop.co.jp/~68user/unix/pickup?date/
# しらべたところ、
# env TZ=JST+167 (9+167 / 24 = 7.333...)つまり1週間前までは
# 日付を取得する事ができる。
# ただ、かんがえれば考える程なんか変だな…この動きは。
# これって"JST+167"を"9+167"と解釈しているわけではないらしい。
