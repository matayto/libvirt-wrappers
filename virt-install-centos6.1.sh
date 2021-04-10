#!/bin/bash

source ./virt-common.sh

#iso_name="CentOS-6.1-x86_64-LiveCD.iso"
#iso_name="CentOS-6.1-x86_64-netinstall.iso"
#iso_name="CentOS-6.1-x86_64-minimal.iso"
# isoinfo -f -i <image>.iso
iso_name="CentOS-6.1-x86_64-bin-DVD1.iso"
iso_url="https://vault.centos.org/6.1/isos/x86_64/${iso_name}"
vm_name="centos6.1"
vm_disk="20G"
# osinfo-query os | grep centos
os_variant="centos6.1"

get_iso "${iso_url}" "${iso_name}"
create_vm_fs "${vm_name}" "${vm_disk}"

if sudo virsh list --all | grep -q "${vm_name}"; then
	echo "${vm_name} already exists, not attempting to recreate."
else
	sudo virt-install \
		--debug \
               --name "${vm_name}" \
               --description "${vm_name}" \
               --ram "4096" \
               --vcpus "2" \
               --disk path="${vms_dir}/${vm_name}/${vm_name}.qcow2",bus=virtio,cache=none \
               --os-type "linux" \
               --os-variant "${os_variant}" \
               --graphics "vnc,listen=127.0.0.1" \
               --location "${iso_dir}/${iso_name},kernel=isolinux/vmlinuz,initrd=isolinux/initrd.img" \
               --noautoconsole \
               --network network="${vm_network}" \
               --initrd-inject=unattended/centos6.1.ks.cfg --extra-args "ks=file:/centos6.1.ks.cfg"
fi
