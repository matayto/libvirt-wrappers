#!/bin/bash

vm="$1"

if [[ -z "${1}" ]]; then
  echo "Please define a vm to clean up, from 'virst list --all'"
  exit 1
fi

virsh destroy "${vm}"
virsh undefine "${vm}"
rm -rvf "/var/lib/libvirt/images/${vm}"
