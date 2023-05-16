PACKER_CACHE_DIR := $(builddir)/packer_cache
UNAME := $(shell uname)
OUTPUT_DIR := ./target/build
VM_NAME := alpine-base.raw

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

# use `@` to hide command
pre-build:
	@task -t Taskfile.local.yml

build-qemu:
	@packer build \
		-var "accel=$(accel)" \
		-var "display=$(display)" \
		-var "headless=$(headless)" \
		-force -only qemu.alpine-base .

qemu: pre-build build-qemu compress

build-vb:
	@packer build \
		-var "accel=$(accel)" \
		-var "display=$(display)" \
		-var "headless=$(headless)" \
		-force -only virtualbox-iso.alpine-base .

virtualbox: pre-build build-vb extract convert compress clean

clean:
	@rm -vf $(OUTPUT_DIR)/$(VM_NAME)-disk001.vmdk $(OUTPUT_DIR)/$(VM_NAME).ova

compress:
	@pigz $(OUTPUT_DIR)/$(VM_NAME)

convert:
	@qemu-img convert -f vmdk $(OUTPUT_DIR)/$(VM_NAME)-disk001.vmdk -O raw $(OUTPUT_DIR)/$(VM_NAME)

extract: 
	@tar -C $(OUTPUT_DIR) -xf $(OUTPUT_DIR)/$(VM_NAME).ova $(VM_NAME)-disk001.vmdk

.PHONY: qemu pre-build virtualbox extract convert clean compress
