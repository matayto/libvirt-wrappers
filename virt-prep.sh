#!/bin/bash

sudo dnf -y install remmina bridge-utils
sudo dnf -y groupinstall virtualization
sudo systemctl --now enable libvirtd
sudo virsh net-autostart default
sudo virsh net-start default
sudo brctl show
