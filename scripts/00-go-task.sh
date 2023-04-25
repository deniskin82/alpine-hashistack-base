#!/bin/sh
echo "Install go-task"
set -xe
# https://github.com/go-task/task/releases
TASK_VER="v3.23.0"
OS_ARCH="$(apk --print-arch)";

apk add curl tar

case "$OS_ARCH" in
    x86_64) TASK_ARCH="amd64" ;;
    aarch64) TASK_ARCH="arm64" ;;
    armv5*) TASK_ARCH="arm" ;;
    armv6*) TASK_ARCH="arm" ;;
    armv7*) TASK_ARCH="arm" ;;
    armhf) TASK_ARCH="arm" ;;
    *) echo >&2 "error: unsupported architecture ($OS_ARCH)"; exit 1 ;;
esac;

curl -sSL https://github.com/go-task/task/releases/download/${TASK_VER}/task_linux_${TASK_ARCH}.tar.gz -o /tmp/task_linux.tar.gz
tar -C /usr/bin/ -zxf /tmp/task_linux.tar.gz task
rm -fv /tmp/task_linux.tar.gz
task --version

sync
exit 0
