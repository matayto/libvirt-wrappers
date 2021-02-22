#!/bin/bash

vms_dir="/var/lib/libvirt/images"
iso_dir="${vms_dir}/iso"
# run ./virt-prep-bridge.sh to configure bridging, otherwise use 'default' here
vm_network="host-bridge"

if ! [ -d "${iso_dir}" ]; then
  sudo mkdir -v "${iso_dir}"
fi

get_iso() {
        iso_url=$1
        iso_name=$2
	if ! [ -e "${iso_dir}/${iso_name}" ]; then
		sudo wget "${iso_url}" -O "${iso_dir}/${iso_name}"
	else
		echo "${iso_name} already downloaded, not re-downloading."
	fi
}

create_vm_fs() {
        vm_name=$1
        vm_disk=$2
	dir="${vms_dir}/${vm_name}"
	disk_image="${dir}/${vm_name}.qcow2"

	echo "# Creating ${vm_name} from ISO"

	if ! [ -d "${dir}" ]; then
		sudo mkdir -pv "${dir}"
	fi

	if [ -e "${disk_image}" ]; then
		echo "${disk_image} already exists, not modifying."
	else
		sudo qemu-img create -f qcow2 "${disk_image}" "${vm_disk}"
	fi
}
