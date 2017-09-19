#!/bin/sh

# ==============================================================================
#   機能
#     makeコマンドのラッパースクリプト
#   構文
#     USAGE 参照
#
#   Copyright (c) 2004-2017 Yukio Shiiya
#
#   This software is released under the MIT License.
#   https://opensource.org/licenses/MIT
# ==============================================================================

######################################################################
# 関数定義
######################################################################
USAGE() {
	cat <<- EOF 1>&2
		Usage:
		    make.sh [OPTIONS ...] SRC_DIR
		
		OPTIONS:
		    -u EXEC_USER
		    -e ENV=VAL
		       You may use this option several times.
		    -t "MAKE_TARGETS ..."
		    --help
		       Display this help and exit.
	EOF
}

######################################################################
# 変数定義
######################################################################
if [ "${PROCESSOR_ARCHITECTURE}" = "AMD64" ];then
	CYGWINROOT="${SYSTEMDRIVE}\\cygwin64"
else
	CYGWINROOT="${SYSTEMDRIVE}\\cygwin"
fi
MAKE="make"
EXEC_USER=""
MAKE_TARGETS=""
ENV_OPTIONS=""						#初期状態が「空文字」でなければならない変数

######################################################################
# メインルーチン
######################################################################

# オプションのチェック
CMD_ARG="`getopt -o u:e:t: -l help -- \"$@\" 2>&1`"
if [ $? -ne 0 ];then
	echo "-E ${CMD_ARG}" 1>&2
	USAGE;exit 1
fi
eval set -- "${CMD_ARG}"
while true ; do
	opt="$1"
	case "${opt}" in
	-u)	EXEC_USER="$2" ; shift 2;;
	-e)	ENV_OPTIONS="${ENV_OPTIONS} -e $2" ; shift 2;;
	-t)	MAKE_TARGETS="$2" ; shift 2;;
	--help)
		USAGE;exit 0
		;;
	--)
		shift 1;break
		;;
	esac
done

# 第1引数のチェック
if [ "$1" = "" ];then
	echo "-E Missing SRC_DIR argument" 1>&2
	USAGE;exit 1
else
	SRC_DIR=`echo "$1" | sed "s,/$,,"`
	# ソースディレクトリのチェック
	if [ ! -d "${SRC_DIR}" ];then
		echo "-E SRC_DIR not a directory -- \"${SRC_DIR}\"" 1>&2
		USAGE;exit 1
	fi
fi

# メインルーチン
if [ "`id -un`" = "${EXEC_USER}" ];then
	(set -x; cd "${SRC_DIR}" && ${MAKE} ${ENV_OPTIONS} ${MAKE_TARGETS})
else
	case `uname -s` in
	CYGWIN_*)
		runas.exe /user:${EXEC_USER} "cmd.exe /a /c \"${CYGWINROOT}\\bin\\bash.exe --login -c \"cd ${SRC_DIR} ; ${MAKE} ${ENV_OPTIONS} ${MAKE_TARGETS} ; pause.sh\"\""
		;;
	MINGW32_* | MSYS_*)
		runas.exe //user:${EXEC_USER} "cmd.exe /a /c \"set LOGONSERVER=\\\\${COMPUTERNAME}& ${SYSTEMDRIVE}\\mingw\\msys\\1.0\\bin\\bash.exe --login -c \"cd ${SRC_DIR} ; ${MAKE} ${ENV_OPTIONS} ${MAKE_TARGETS} ; pause.sh\"\""
		;;
	*)
		(set -x; cd "${SRC_DIR}" && sudo -H -u ${EXEC_USER} ${MAKE} ${ENV_OPTIONS} ${MAKE_TARGETS})
		;;
	esac
fi

