builddir := target
PACKER_CACHE_DIR := $(builddir)/packer_cache

alpine_path := alpine-standard-3.17.3-x86_64.iso
alpine_download_uri := https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/x86_64/$(alpine_path)

all: download-iso build

download-iso:
	mkdir -p $(builddir)/iso
	wget -c -P $(builddir)/iso $(alpine_download_uri)
	wget -c -P $(builddir)/iso $(alpine_download_uri).sha256
	wget -c -P $(builddir)/iso $(alpine_download_uri).asc

pre-build:
	task -t Taskfile.local.yml

build: pre-build
	packer build -force -only qemu.alpine-base .

.PHONY: download-iso build pre-build
