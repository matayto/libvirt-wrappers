#!/bin/bash
# run as root
# this takes down nmcli connection for $interface below,
# replacing it with $bridge_name

export interface="enp0s31f6"
export con_name="wired"
export bridge_name="br0"
export libvirt_bridge="host-bridge"

#nmcli dev status
#nmcli con add con-name ${con_name} ifname ${interface} type ethernet

bash -x <<EOS
systemctl stop libvirtd
if ! nmcli con show | grep -Ewq "^${bridge_name}"; then
  nmcli con add type bridge ifname "${bridge_name}" autoconnect yes con-name "${bridge_name}" stp off
  #nmcli c modify br0 ipv4.addresses 192.168.1.99/24 ipv4.method manual
  #nmcli c modify br0 ipv4.gateway 192.168.1.1
  #nmcli c modify br0 ipv4.dns 192.168.1.1
fi
if ! nmcli con show | grep -Eq "^br0-${interface}"; then
  nmcli con add type bridge-slave autoconnect yes con-name "br0-${interface}" ifname "${interface}" master "${bridge_name}"
  nmcli con down "${con_name}"
  nmcli con up "${bridge_name}"
fi
systemctl restart NetworkManager
systemctl start libvirtd
systemctl enable libvirtd
if ! [ -e /etc/sysctl.d/99-ip_forward.conf ]; then
  echo "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/99-ip_forward.conf
  sysctl -p /etc/sysctl.d/99-ip_forward.conf
fi
if ! [ -e /etc/sysctl.d/99-bridge.conf ]; then
  echo "net.bridge.bridge-nf-call-ip6tables = 0" | tee /etc/sysctl.d/99-bridge.conf
  echo "net.bridge.bridge-nf-call-iptables = 0" | tee /etc/sysctl.d/99-bridge.conf
  echo "net.bridge.bridge-nf-call-arptables = 0" | tee /etc/sysctl.d/99-bridge.conf
  sysctl -p /etc/sysctl.d/99-bridge.conf
fi
nmcli con show --active
EOS

cat > bridge.xml <<EOF
<network>
  <name>${libvirt_bridge}</name>
  <forward mode="bridge"/>
  <bridge name="${bridge_name}"/>
</network>
EOF

if ! virsh net-list --all | grep -wq "${libvirt_bridge}"; then
  virsh net-define bridge.xml
  virsh net-start host-bridge
  virsh net-autostart host-bridge
fi

rm -vf bridge.xml
virsh net-list --all
