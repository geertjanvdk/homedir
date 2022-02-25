#!/bin/sh
set -e -o pipefail

HD=$(cd "$(dirname $0)"; pwd)
if [ "$(dirname $HD)" != "$HOME" ]; then
	echo "homedir project must be subfolder of $HOME"
	exit 1
fi
echo $HD

USER_GROUP=$(id -gn ${USER})
BACKUP_DIR=${HOME}/.backup_homedir
cd ${HOME}

backup ()
{
	if [ "$1" == "" ]; then
		echo "source missing for backup"
		exit 1
	fi

	if [ "$2" == "" ]; then
		echo "destination missing for backup"
		exit 1
	fi

	if [ ! -e "$1" ]; then
		# nothing to do
		return
	fi

	if [ ! -d ${BACKUP_DIR} ]; then
		mkdir -p ${BACKUP_DIR}
	fi

	echo "  backing up: $1 -> ${BACKUP_DIR}/$2"
	mv $1 ${BACKUP_DIR}/$2
}

setup_basic_config_file ()
{
	name="${1}"
	src="${HD}/${2}"
	dst="${HOME}/${3}"
	backup_file="${3}"

	if [ "${src}" == "" ]; then
		echo "(panic) source not provided"
		exit 1
	fi

	if [ "${dst}" == "" ]; then
		echo "(panic) destination not provided"
		exit 1
	fi

	if [ ! -e "${src}" ]; then
		echo "(panic) source '${src}' does not exist"
		exit 2
	fi

	if [ ! -f "${src}" ]; then
		echo "(panic) source '${src}' must be regular file"
		exit 2
	fi

	if [ -L "${dst}" ]; then
		echo "Skipping ${name}."
		return
	fi

	echo "Set up ${name} .. "
	backup ${dst} ${backup_file}

	echo "  link ${src} -> ${dst}" 
	ln -s ${src} ${dst}
	chmod 0600 ${dst}

	echo "  done!"
}

##
## SSH
##
setup_ssh () {
	if [ -L ${HOME}/.ssh/authorized_keys ]; then
		echo "Skipping SSH."
		return
	fi

	echo "Set up SSH .. "

	if [ -f ${HOME}/.ssh/authorized_keys ]; then
		mkdir -p ${BACKUP_DIR}/ssh
		backup ${HOME}/.ssh/authorized_keys ssh
	fi

	if [ ! -d ${HOME}/.ssh ]; then
		mkdir ${HOME}/.ssh
	fi

	chown -R ${USER}:${USER_GROUP} ${HOME}/.ssh/
	chmod 0700 ${HOME}/.ssh/
	chmod g+s ${HOME}/.ssh/

	ln -s ${HD}/ssh/authorized_keys ${HOME}/.ssh/authorized_keys
	chmod 0600 ${HD}/ssh/authorized_keys

	echo "  done!"
}

setup_ssh
setup_basic_config_file "ZSH" "zshrc" ".zshrc"
setup_basic_config_file "Git" "gitconfig" ".gitconfig"
setup_basic_config_file "VIm" "vimrc" ".vimrc"

