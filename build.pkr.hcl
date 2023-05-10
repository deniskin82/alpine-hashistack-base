variable "root_password" {
  type      = string
  default   = "alpinealpine"
  sensitive = true
}

variable "iso_checksum" {
  type    = string
  default = "3e699e0853fe43b328bdb643adb226a47026586ab3a64a8aec03fac570aca193"
}

variable "iso_file" {
  type    = string
  default = "./http/iso/alpine-standard-3.17.3-x86_64.iso"
}

variable "vm_name" {
  type    = string
  default = "alpine-base"
}

variable "version" {
  type    = string
  default = "3.17.3"
}

variable "disk_size" {
  type    = string
  default = "2G"
}

variable "cpus" {
  type    = string
  default = "2"
}

variable "memory" {
  type    = string
  default = "1024"
}

variable "accel" {
  default     = "hvf"
  description = "hvf for macOS, kvm for Linux"
}

variable "headless" {
  type    = string
  default = "true"
}

variable "display" {
  type        = string
  default     = "cocoa"
  description = "cocoa for macOS"
}

variable "boot_wait" {
  default     = "20s"
  description = "if no accel, should set at least 30s"
}

variable "ssh_wait_timeout" {
  type    = string
  default = "90s"
}

variable "format" {
  type    = string
  default = "raw"
}

variable "output_directory" {
  type    = string
  default = "./target/build/"
}

source "qemu" "alpine-base" {
  iso_url      = var.iso_file
  iso_checksum = var.iso_checksum

  cpus        = var.cpus
  memory      = var.memory
  display     = var.display
  headless    = var.headless
  accelerator = var.accel

  ssh_username = "root"
  ssh_password = var.root_password

  boot_wait         = var.boot_wait
  boot_key_interval = "10ms"
  boot_command = [
    "root<enter><wait>",
    "ifconfig eth0 up && udhcpc -i eth0<enter><wait5>",
    "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/answers<enter><wait>",
    "setup-alpine -f answers<enter><wait10>",
    "${var.root_password}<enter><wait>",
    "${var.root_password}<enter>",
    "<wait20s>y<enter><wait30s>",
    "reboot<enter><wait30s>",
    "root<enter><wait>",
    "${var.root_password}<enter><wait>",
    "sed -i 's/^#PermitRootLogin .*/PermitRootLogin yes/g' /etc/ssh/sshd_config<enter>",
    "service sshd restart<enter><wait4s>",
    "exit<enter><wait20s>"
  ]

  http_directory = "http"

  disk_size        = "${var.disk_size}"
  disk_interface   = "ide"
  format           = "${var.format}"
  output_directory = "${var.output_directory}"

  shutdown_command = "/sbin/poweroff"

  ssh_wait_timeout = "${var.ssh_wait_timeout}"
  vm_name          = "${var.vm_name}.${var.format}"
}

build {
  sources = ["source.qemu.alpine-base"]

  provisioner "file" {
    source = "taskfiles"
    destination = "taskfiles"
  }

  provisioner "file" {
    source = "Taskfile.yml"
    destination = "Taskfile.yml"
  }

  provisioner "file" {
    source = "local.env"
    destination = "local.env"
  }

  provisioner "shell" {
    execute_command = "{{.Vars}} /bin/sh -x '{{ .Path }}'"
    scripts = [
      "scripts/00-go-task.sh",
    ]
  }

  provisioner "shell" {
    inline = [
      "task -d ."
    ]
  }

  provisioner "shell" {
    execute_command = "/bin/sh -x '{{ .Path }}'"
    scripts = [
      "scripts/99-cleanup.sh"
    ]
  }

  // post-processors {
  //   post-processor "compress" {
  //     output = "output/disk.raw.tar.gz"
  //     compression_level = 9
  //   }
  // }
}
