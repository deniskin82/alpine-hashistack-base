PACKER_CACHE_DIR := $(builddir)/packer_cache
UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
accel=kvm
endif
ifeq ($(UNAME), Darwin)
accel=hvf
endif

all: build

pre-build:
	task -t Taskfile.local.yml

build: pre-build
	packer build \
		-var "accel=$(accel)" \
		-force -only qemu.alpine-base .

.PHONY: build pre-build test
