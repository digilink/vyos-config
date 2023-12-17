#!/bin/vbash

set service dhcp-server hostfile-update
set service dhcp-server host-decl-name
set service dhcp-server listen-address '10.0.100.254'

# VLAN 100 - servers
set service dhcp-server shared-network-name vlan-100 authoritative
set service dhcp-server shared-network-name vlan-100 ping-check
set service dhcp-server shared-network-name vlan-100 subnet 10.0.100.0/24 default-router '10.0.100.254'
set service dhcp-server shared-network-name vlan-100 subnet 10.0.100.0/24 domain-name 'sblan.network'
set service dhcp-server shared-network-name vlan-100 subnet 10.0.100.0/24 lease '86400'
set service dhcp-server shared-network-name vlan-100 subnet 10.0.100.0/24 name-server '10.0.5.4'
set service dhcp-server shared-network-name vlan-100 subnet 10.0.100.0/24 range 0 start '10.0.100.26'
set service dhcp-server shared-network-name vlan-100 subnet 10.0.100.0/24 range 0 stop '10.0.100.200'

