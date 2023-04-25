PACKER_CACHE_DIR := $(builddir)/packer_cache

all: build

pre-build:
	task -t Taskfile.local.yml

build: pre-build
	packer build -force -only qemu.alpine-base .

.PHONY: build pre-build
