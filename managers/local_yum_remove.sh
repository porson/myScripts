#!/bin/bash
#author:leepx

read -p "请确认原repo文件已备份 按任意建继续 ..."
repos="/etc/yum.repos.d"
find $repos/ -name *.repo -exec mv {} $repos/ \; &>/dev/null
[ -f $repos/local.repo ]&&rm -f $repos/local.repo
[ -d $repos/bak ]&&rm -rf $repos/bak
yum clean all
echo "yum源恢复完成"
