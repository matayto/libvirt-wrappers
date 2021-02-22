#!/bin/bash

source ./virt-common.sh

iso_name="CentOS-7-x86_64-Minimal-2009.iso"
iso_url="http://mirror.cs.pitt.edu/centos/7.9.2009/isos/x86_64/${iso_name}"
vm_name="centos7-base"
vm_disk="20G"
os_variant="centos7.0"
vnc_port="5901"

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
               --network network="${vm_network}" \
               --initrd-inject=unattended/centos7-base.ks.cfg --extra-args "ks=file:/centos7-base.ks.cfg"
fi
