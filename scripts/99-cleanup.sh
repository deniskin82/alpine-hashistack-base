#!/bin/sh

set -ux

rm -rvf /var/cache/apk/* taskfiles Taskfile.yml

dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Block until the empty file has been removed, otherwise, Packer
# will try to kill the box while the disk is still full and that's bad
sync

sleep 10
exit 0
