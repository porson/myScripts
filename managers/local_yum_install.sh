#!/bin/bash
repos="/etc/yum.repos.d"

local_yum(){

	cat >$repos/local.repo <<EOF
[local_yum]
name=local_yum
baseurl=file:///mnt
gpgcheck=0
enabled=1
EOF

	read -p "请确认光盘已经放入光驱中，按任意建继续 ..."
	mount /dev/cdrom /mnt &>/dev/null
	case $? in
	0)
		yum clean all &>/dev/null
		yum update && echo "本地yum源配置成功！"
		;;
	32)
		yum clean all &>/dev/null
		echo "光盘已经挂载！"
		;;
	*)
		echo "请放入光盘！"
		;;
	esac
}
if [ -d $repos/bak ]
then
	if [ -f $repos/local.repo ]
	then
		rm -f $repos/local.repo
		local_yum
	else
		local_yum
	fi
else
	mkdir $repos/bak
	mv $repos/*.repo $repos/bak
	local_yum
fi
