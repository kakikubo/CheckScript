#
# $Id$
#
# ~/.ck のサンプルファイルです。

# 
# 稼働確認する対象のプロセスを登録します
#
PROCESS="httpd\
	lpd"

# 以下に登録を行った場合、syslogを色付けあり、で閲覧できます。
# 日付は当日と前日のものを持ってきます
SYSLOG="/var/log/messages \
	/var/log/messages.0.gz"

# テープデバイスをチェックする時は以下の変数に
# 直接デバイスをかきこんでください。
TAPE="/dev/nst0"

# 以下は普通のファイルを閲覧します。一応、色付けもします。
#
LOG="/var/log/xdm.log"

#
# sudoコマンドを有効にすると、全てのコマンドをsudo付きで
# 実行します。
SUDO="yes"

#
#  以下のキーワードは無視します。ただし、全てのログファイルに対して
#  除外してしまうので注意が必要です
IG1='hoge'
IG2='nmbd'
IG3='/kernel'
IGNORE="($IG1|$IG2|$IG3)"
