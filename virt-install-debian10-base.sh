#!/bin/bash

source ./virt-common.sh

iso_name="debian-10.8.0-amd64-netinst.iso"
iso_url="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/${iso_name}"
vm_name="debian10-base"
vm_disk="20G"
os_variant="debian10"
vnc_port="5902"

get_iso "${iso_url}" "${iso_name}"
create_vm_fs "${vm_name}" "${vm_disk}"

if sudo virsh list --all | grep -q "${vm_name}"; then
	echo "${vm_name} already exists, not attempting to recreate."
else
	sudo virt-install \
              --name "${vm_name}" \
              --description "${vm_name}" \
              --ram "4096" \
              --vcpus "2" \
              --disk path="${vms_dir}/${vm_name}/${vm_name}.qcow2",bus=virtio,cache=none \
              --os-type "linux" \
              --os-variant "${os_variant}" \
              --graphics "vnc,listen=127.0.0.1,port=${vnc_port}" \
              --location "${iso_dir}/${iso_name}" \
              --noautoconsole \
              --initrd-inject=unattended/preseed.cfg
fi
