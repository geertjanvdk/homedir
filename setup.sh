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

	mv $1 ${BACKUP_DIR}/$2
}

##
## SSH
##
setup_ssh () {
	if [ -L ${HOME}/.ssh/authorized_keys ]; then
		echo "Skipping SSH."
		return
	fi

	echo -n "Set up SSH .. "

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

	echo "done!"
}

###
### ZSH
###
setup_zsh ()
{
	if [ -L .zshrc ]; then
		echo "Skipping ZSH."
		return
	fi

	echo -n "Set up ZSH .. "
	backup ${HOME}/.zshrc zshrc

	ln -s ${HD}/zshrc ${HOME}/.zshrc
	chmod 0600 ${HD}/zshrc

	echo "done!"
}

###
### Git
###
setup_git ()
{
	if [ -L .gitconfig ]; then
		echo "Skipping Git."
		return
	fi

	echo -n "Set up Git .. "
	backup ${HOME}/.gitconfig gitconfig

	ln -s ${HD}/gitconfig ${HOME}/.gitconfig
	chmod 0600 ${HD}/gitconfig

	echo "done!"
}

setup_ssh
setup_zsh
setup_git
