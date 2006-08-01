#!/bin/sh
# $Id$


############################################################
# ・vmstat の値を取得して CSV 形式でファイルに出力する。 
#   取得した値を元に、メモリ、CPU の使用状況をチェックし 
#   設定したしきい値を超えていた場合は、警告メールを送信する。
# 
# ・変数として設定してある、計算に用いる値は、OS によって
#   出力形式が多少異なるので、 使用する OS に合わせて
#   適宜変更する必要がある。
#
#
# ・vmstatコマンドからヘッダを取得するように変更をかけた。
############################################################
# require
#         nkf
############################################################


PATH=/usr/bin:/bin:/sbin

####### 変数の定義
MONTH=`date +%Y%m`
VMST_LOG=${HOME}/log/vmst-${MONTH}.csv
VMST_HEADER="date`vmstat 1 1| awk 'NR == 2' | tr -s ' ' ',' `"

MEM_THRESHOLD=90    #...%(空き)
CPU_THRESHOLD=99    #...%(空き)

####### メール通知関連の変数
MAIL_ADDRS='kakikubo@sra-osc.ne.jp'

####### 関数の定義

### 関数名 : writeVmstatVal
### 機能 : vmstat の値のファイル出力(CSV 形式)
### 入力 : $1 : 出力先ファイル名
###      : $2 : vmstat の値
### 出力 : なし
### 戻値 : なし
writeVmstatVal() {
	if [ ! -f $1 ]; then
		echo "${VMST_HEADER}" >> $1
	fi

	echo `date +%Y/%m/%d:%H:%M` "$2" | tr -s ' ' ',' >> $1
}
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

### 関数名 : calcUsageMEM
### 機能 : 使用可能メモリ(%)の計算
### 入力 : $1 : vmstat の値
### 出力 : 使用可能メモリ(%)
### 戻値 : なし
calcUsageMEM() {
	### 空きメモリ = free + baff + cache
	usgMEM=`
		echo $1 \
		| awk -v totalmem=${TOTALMEM} '
			{ freemem = $5 + $6 + $7 }
			END { print int(freemem / totalmem * 100) }
		'
	`
  echo "${usgMEM}"
}

### 関数名 : getIdleCPUVal
### 機能 : Idle CPU(%) の取得
### 入力 : $1 : vmstat の値
### 出力 : Idle CPU(%)
### 戻値 : なし
getIdleCPUVal() {
	idlCPU=`echo $1 | awk '{print $NF}'`

	echo "${idlCPU}"
}

### 関数名 : sendAlertMail
### 機能 : MEM or CPU のしきい値超えの警告メール送信
### 入力 : $1 : MEM or CPU
###      : $2 : 使用可能 MEM or CPU の値(%)
### 戻値 : なし
sendAlertMail() {
	USED=`expr 100 - $2`
	case $1 in
		MEM)
			MAIL_SUB="### Warning ! `hostname`'s MEMORY was used ${USED}%"
			BODY_SUB="メモリ使用率"
			;;
		CPU)
			MAIL_SUB="### Warning ! `hostname`'s CPU was used ${USED}%"
			BODY_SUB="CPU 使用率"
			;;
	esac

	nkf -j <<- END | mail -s "${MAIL_SUB}" ${MAIL_ADDRS}
		`hostname` の "${BODY_SUB}" が ${USED}% に達しました。
		ご確認ください。_(._.)_

		========== top -b -n3 -d1 ==========
		`top -b -s1 -d3`
	END
}
    
##########################
####### メイン部分 #######
##########################


WHATOS=`Ostype`
case "${WHATOS}" in
    FREEBSD) 
	TOTALMEM=`sysctl hw.usermem | awk '{print $2}'`
	;;
    LINUX)
	TOTALMEM=`awk 'NR == 4' /proc/meminfo  | awk '{print $2}'`
	;;
esac


### vmstat の値取得
VMST_VAL="`vmstat 5 2 | tail -1`"

### vmstat の値書き出し
writeVmstatVal ${VMST_LOG} "${VMST_VAL}"