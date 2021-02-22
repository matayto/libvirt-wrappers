# libvirt wrappers

A collection of scripts to quickly spin up libvirt, bridging, and baseline guests.

Note that the sample unattended configurations used for initrd injection (kickstart for EL, preseed for Debian) are incredibly insecure and should only be used in a testing or lab environment.

## Instructions

1. Run `virt-prep.sh` to install the virtualization components, including a default NAT network.
1. Run `virt-prep-bridge.sh` to configure the host for bridged networking.
1. Update `virt-common.sh` to set up base directories and the network name guests should join.
1. Run, or copy/modify to suit needs, `virt-install-centos7-base.sh` to create a minimal CentOS 7 base image.

## TODO

1. virt-clone setup

