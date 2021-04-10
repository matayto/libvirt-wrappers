#!/bin/bash

sudo dnf -y groupinstall virtualization
sudo dnf -y install remmina bridge-utils libguestfs-tools-c
sudo systemctl --now enable libvirtd
sudo virsh net-autostart default
sudo virsh net-start default
sudo brctl show
