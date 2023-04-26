#!/bin/sh
echo "Install go-task"
. ~/taskfiles/files/base.cfg
TASK_PKG="/tmp/task_linux.tar.gz"

set -xe
apk add curl tar

curl -sSL http://${PACKER_HTTP_ADDR}/tools/task_linux_amd64_${TASK_VERSION}.tar.gz -o ${TASK_PKG}
tar -C /usr/bin/ -zxf ${TASK_PKG} task
rm -fv ${TASK_PKG}
task --version

sync
exit 0
