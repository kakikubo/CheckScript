#!/bin/sh
# $Id$


############################################################
# ��vmstat ���ͤ�������� CSV �����ǥե�����˽��Ϥ��롣 
#   ���������ͤ򸵤ˡ����ꡢCPU �λ��Ѿ���������å��� 
#   ���ꤷ���������ͤ�Ķ���Ƥ������ϡ��ٹ�᡼����������롣
# 
# ���ѿ��Ȥ������ꤷ�Ƥ��롢�׻����Ѥ����ͤϡ�OS �ˤ�ä�
#   ���Ϸ�����¿���ۤʤ�Τǡ� ���Ѥ��� OS �˹�碌��
#   Ŭ���ѹ�����ɬ�פ����롣
#
#
# ��vmstat���ޥ�ɤ���إå����������褦���ѹ��򤫤�����
############################################################
# require
#         nkf
############################################################


PATH=/usr/bin:/bin:/sbin

####### �ѿ������
MONTH=`date +%Y%m`
VMST_LOG=${HOME}/log/vmst-${MONTH}.csv
VMST_HEADER="date`vmstat 1 1| awk 'NR == 2' | tr -s ' ' ',' `"

MEM_THRESHOLD=90    #...%(����)
CPU_THRESHOLD=99    #...%(����)

####### �᡼�����δ�Ϣ���ѿ�
MAIL_ADDRS='kakikubo@sra-osc.ne.jp'

####### �ؿ������

### �ؿ�̾ : writeVmstatVal
### ��ǽ : vmstat ���ͤΥե��������(CSV ����)
### ���� : $1 : ������ե�����̾
###      : $2 : vmstat ����
### ���� : �ʤ�
### ���� : �ʤ�
writeVmstatVal() {
	if [ ! -f $1 ]; then
		echo "${VMST_HEADER}" >> $1
	fi

	echo `date +%Y/%m/%d:%H:%M` "$2" | tr -s ' ' ',' >> $1
}
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

### �ؿ�̾ : calcUsageMEM
### ��ǽ : ���Ѳ�ǽ����(%)�η׻�
### ���� : $1 : vmstat ����
### ���� : ���Ѳ�ǽ����(%)
### ���� : �ʤ�
calcUsageMEM() {
	### �������� = free + baff + cache
	usgMEM=`
		echo $1 \
		| awk -v totalmem=${TOTALMEM} '
			{ freemem = $5 + $6 + $7 }
			END { print int(freemem / totalmem * 100) }
		'
	`
  echo "${usgMEM}"
}

### �ؿ�̾ : getIdleCPUVal
### ��ǽ : Idle CPU(%) �μ���
### ���� : $1 : vmstat ����
### ���� : Idle CPU(%)
### ���� : �ʤ�
getIdleCPUVal() {
	idlCPU=`echo $1 | awk '{print $NF}'`

	echo "${idlCPU}"
}

### �ؿ�̾ : sendAlertMail
### ��ǽ : MEM or CPU �Τ�������Ķ���ηٹ�᡼������
### ���� : $1 : MEM or CPU
###      : $2 : ���Ѳ�ǽ MEM or CPU ����(%)
### ���� : �ʤ�
sendAlertMail() {
	USED=`expr 100 - $2`
	case $1 in
		MEM)
			MAIL_SUB="### Warning ! `hostname`'s MEMORY was used ${USED}%"
			BODY_SUB="�������Ψ"
			;;
		CPU)
			MAIL_SUB="### Warning ! `hostname`'s CPU was used ${USED}%"
			BODY_SUB="CPU ����Ψ"
			;;
	esac

	nkf -j <<- END | mail -s "${MAIL_SUB}" ${MAIL_ADDRS}
		`hostname` �� "${BODY_SUB}" �� ${USED}% ��ã���ޤ�����
		����ǧ����������_(._.)_

		========== top -b -n3 -d1 ==========
		`top -b -s1 -d3`
	END
}
    
##########################
####### �ᥤ����ʬ #######
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


### vmstat ���ͼ���
VMST_VAL="`vmstat 5 2 | tail -1`"

### vmstat ���ͽ񤭽Ф�
writeVmstatVal ${VMST_LOG} "${VMST_VAL}"