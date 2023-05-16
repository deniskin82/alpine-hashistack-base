PACKER_CACHE_DIR := $(builddir)/packer_cache
UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
accel=kvm
display="gtk"
headless="false"
endif
ifeq ($(UNAME), Darwin)
display="cocoa"
headless="false"
accel=hvf
endif

all: qemu

pre-build:
	task -t Taskfile.local.yml

qemu: pre-build
	packer build \
		-var "accel=$(accel)" \
		-var "display=$(display)" \
		-var "headless=$(headless)" \
		-force -only qemu.alpine-base .

virtualbox: pre-build
	packer build \
		-var "accel=$(accel)" \
		-var "display=$(display)" \
		-var "headless=$(headless)" \
		-force -only virtualbox-iso.alpine-base .

.PHONY: qemu pre-build virtualbox
