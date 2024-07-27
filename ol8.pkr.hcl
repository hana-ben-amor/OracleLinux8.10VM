variable "cpus" {}
variable "disk_size" {}
variable "headless" {}
variable "hostname" {}
variable "http_proxy" {}
variable "https_proxy" {}
variable "iso_checksum" {}
variable "iso_checksum_type" {}
variable "iso_url" {}
variable "memory" {}
variable "no_proxy" {}
variable "ssh_fullname" {}
variable "ssh_password" {}
variable "ssh_username" {}
variable "update" {}
variable "version" {}
variable "virtualbox_guest_os_type" {}
variable "vm_name" {}
variable "home" {}




source "virtualbox-iso" "autogenerated_1" {
 
  boot_command= [
         
        "<esc><wait>",
        "vmlinuz initrd=initrd.img inst.ks=http://172.20.10.2:{{ .HTTPPort }}/ks.cfg",
        "<enter>"
      ]

  disk_size               = "${var.disk_size}"
  guest_os_type           = "${var.virtualbox_guest_os_type}"
  hard_drive_interface    = "sata"
  headless                = "${var.headless}"
  http_directory          = "./http"
  iso_checksum            = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_urls                = [
    "${var.iso_url}"
  ]
  output_directory        = "output3" 
  shutdown_command        = "echo '${var.ssh_password}'|sudo -S shutdown -P now" 
  ssh_username            = "${var.ssh_username}"
  ssh_password            = "${var.ssh_password}"
  ssh_wait_timeout        = "10000s"
  guest_additions_mode    = "disable"
  vboxmanage             = [
    ["modifyvm", "{{ .Name }}", "--audio", "none"], 
    ["modifyvm", "{{ .Name }}", "--usb", "off"],
    #vram: c quoi 
    ["modifyvm", "{{ .Name }}", "--vram", "12"], #variable
    ["modifyvm", "{{ .Name }}", "--vrde", "off"], 
    // ["modifyvm", "{{ .Name }}", "--nictype1", "virtio"], 
    ["modifyvm", "{{.Name}}", "--nic1", "bridged"],
    ["modifyvm", "{{.Name}}", "--bridgeadapter1","Intel(R) Wi-Fi 6E AX211 160MHz"],
    ["modifyvm", "{{ .Name }}", "--memory", "${var.memory}"], 
    ["modifyvm", "{{ .Name }}", "--cpus", "${var.cpus}"],
    // ["modifyvm", "{{ .Name }}", "--natpf1", "guestssh,tcp,,2236,,22"]
  ]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "${var.vm_name}"
  format                  = "ova"
}





build {
  sources = ["source.virtualbox-iso.autogenerated_1"]
  
  provisioner "file" {
  source      = ".ssh/id_ed25519.pub"
  destination = "/tmp/id_ed25519.pub"
}

provisioner "shell" {
  inline = [
    "mkdir -p /home/oracle/.ssh",
    "cat /tmp/id_ed25519.pub >> /home/oracle/.ssh/authorized_keys",
    "chmod 600 /home/oracle/.ssh/authorized_keys",
    "chown oracle:oracle /home/oracle/.ssh /home/oracle/.ssh/authorized_keys",
    "rm /tmp/id_ed25519.pub"
  ]
}




  
}
