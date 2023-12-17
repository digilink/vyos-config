#!/bin/bash
# initial bootstrap script for a newly installed system
# edit as needed
#
# to apply:
# cd /config/bootstrap
# ./bootstrap.sh

source /opt/vyatta/etc/functions/script-template

load /opt/vyatta/etc/config.boot.default

set interfaces ethernet eth0 description 'MGMT'
set interfaces ethernet eth0 address 'dhcp'

set system login user vyos authentication public-keys personal key 'AAAAC3NzaC1lZDI1NTE5AAAAIPIDX41T6jlfjZttTE22gLCF7sfNYiR0Xx0avDCKfQBA'
set system login user vyos authentication public-keys personal type 'ssh-ed25519'

set service ssh disable-password-authentication
set service ssh port '22'

delete system host-name
set system host-name 'gateway'
set system domain-name 'sblan.network'

set system ipv6 disable-forwarding

set system name-server '1.1.1.1'

set system sysctl parameter kernel.pty.max value '24000'

set system time-zone 'America/New_York'

# commit, save changes and exit config
commit; save; exit