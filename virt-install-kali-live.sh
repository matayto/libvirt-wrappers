#!/bin/bash

source ./virt-common.sh

iso_name="kali-linux-2020.4-live-amd64.iso"
iso_url="https://cdimage.kali.org/kali-2020.4/${iso_name}"
vm_name="kali-live"
vm_disk="20G"
os_variant="debian10"

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
               --graphics "vnc,listen=127.0.0.1" \
               --cdrom "${iso_dir}/${iso_name}" \
               --noautoconsole \
               --network network="${vm_network}"
fi
