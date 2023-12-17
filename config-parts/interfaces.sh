#!/bin/vbash

# eth0 - 1gb (MGMT)
# eth1 - 10gb (transit network/VLAN 100)
# eth2 - 10gb 
# eth3 - 1gb
# eth4 - 1gb

# physical interfaces
# eth0
set interfaces ethernet eth0 hw-id a0:8c:fd:eb:e1:68
set interfaces ethernet eth0 address '192.168.5.1/24'
set interfaces ethernet eth0 description 'MGMT' 

# eth1 - 10gb/transit network
set interfaces ethernet eth1 hw-id e4:11:5b:99:ab:81
set interfaces ethernet eth1 address '10.0.0.2/30'
set interfaces ethernet eth1 description '10GB'
set interfaces ethernet eth1 disable-flow-control

# eth2 - 10gb
set interfaces ethernet eth2 hw-id e4:11:5b:99:ab:80
set interfaces ethernet eth2 description '10GB'

# eth3 
set interfaces ethernet eth3 hw-id 00:25:90:33:db:d4

# eth4 
set interfaces ethernet eth4 hw-id 00:25:90:33:db:d5

# vlans
# eth1.100 - VLAN 100
set interfaces ethernet eth1 vif 100
set interfaces ethernet eth1 vif 100 description 'VLAN 100 - servers' 
set interfaces ethernet eth1 vif 100 address 10.0.100.254/24
