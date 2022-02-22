#!/bin/zsh

USER_GROUP=$(id -gn ${USER})

cd ${HOMEDIR}

echo -n "Hardering SSH .. "
chown -R ${USER}:${USER_GROUP} .ssh/
chmod 0700 .ssh/
chmod 0600 .ssh/authorized_keys
echo "done!"
echo
