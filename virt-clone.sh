#!/bin/bash

source ./virt-common.sh

original_vm_name="$1"
vm_name="$2"
dir="${vms_dir}/${vm_name}"
disk_image="${dir}/${vm_name}.qcow2"


if ! [ -d "${dir}" ]; then
	sudo mkdir -pv "${dir}"
fi

if [ -e "${disk_image}" ]; then
	echo "${disk_image} already exists, not modifying."
	exit 1
fi

sudo virt-clone \
  --original "${original_vm_name}" \
  --name "${vm_name}" \
  --file "${disk_image}"

sudo virt-sysprep \
  --domain "${vm_name}" \
  --hostname "${vm_name}" \
  --enable customize,ssh-hostkeys,dhcp-client-state,udev-persistent-net,machine-id,bash-history,ssh-userdir,tmp-files,utmp
