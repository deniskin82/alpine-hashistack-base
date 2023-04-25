#!/bin/sh
echo "Install go-task"
. ~/taskfiles/files/base.cfg

set -xe
# https://github.com/go-task/task/releases
TASK_PKG="task_linux_amd64_${TASK_VERSION}.tar.gz"
tar -C /usr/bin/ -zxf ~/tools/${TASK_PKG} task
rm -fv ~/tools/${TASK_PKG}
task --version

sync
exit 0
