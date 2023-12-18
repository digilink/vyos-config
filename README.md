# vyos-config

My VyOS config. This was oroginally forked from https://github.com/truxnell/vyos-config.

Thanks to bjw-s for the framework for setting up VyOS in a iac/gitops fashion!  
https://github.com/bjw-s/vyos-config

# Hardware I am using
HP Elitedesk 800 G3 SFF PC  
Intel Core i5-7500  (4 cores/3.4 Ghz)  
16gb of DDR4 RAM (probably overkill, but I had spare memory sitting around)  
250gb SATA SSD  
1x dual port 1gb NIC (Intel 82575EB)  
1x dual port 10gb NIC (Intel 82599ES/SFP)  

# Setup
My current configuration is a work in-progress as of December 2023. This router is very barebones, there is no nat or firewalling setup as this is not an edge device for me, but rather sits in front of my home lab infrastructure.  

My networks consist of the following: 

192.168.5.0/24  - home lan on Ubiquiti Unifi stack (I am using eth0 for mgmt on this network)   
10.0.100.0/24   - server vlan 100   

__**NOTE:__ There have been some significant changes in the VyOS code as of the writing of this document. As such, earlier versions than the one I have tested with (noted below) may not work correctly and need commands changed. 

I have tested exclusively with version 1.4-rolling-202312010306, which is available to download here:  

[VyOS 1.4-rolling-202312010306](https://github.com/onedr0p/vyos-build/releases/download/v1.4-rolling-202312010306/1.4-rolling-202312010306-amd64.iso)

The easiest method I have adopted to bootstrap the system from a new install is to download this git directory as a zip, add it to a usb flash drive and runn the bootstrap.sh script located in the bootstrap directory. 

Download the repo as a zip: 
[repo zip](https://github.com/digilink/vyos-config/archive/refs/heads/main.zip)

Transfer the file to a exfat formatted usb stick, plug into VyOS system, mount, and unzip: 

```
mkdir /tmp/usb
usb=/dev/disk/by-id/$(ls /dev/disk/by-id | grep 'usb.*part1')
sudo mount.exfat-fuse -o "rw,user=vyos,gid=vyattacfg" "$usb" /tmp/usb
```

Unzip directory and move files to /config: 
```
cd /tmp/usb
unzip vyos-config-main.zip
cd vyos-config-main
sudo cp -r * /config
sudo chmod -R 2775 /config
```

Reboot

After machine reboots, apply a default bootstrap to put the machine on the network: 
```
cd /config/bootstrap
./bootstrap.sh
```

## Local machine

This project uses sops and age to encrypt secrets. Install both using a package manager (I used homebrew on MacOS), or download the binary from their respective git repo: 

https://github.com/getsops/sops  
https://github.com/FiloSottile/age

Setup for SOPS 

Create a .config directory to place the private key: 

```
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```

Create a .sops.yaml and place in git directory: 

```
---
creation_rules:
  - path_regex: .*\.sops\.env
    # Personal, VyOS
    age: >-
      age14ycev7lkx92hsg054csars36dkkg0lnggxcrh8wdxge7yepaap0q0dn6qr
```

Encrypt a file in place: 

```
sops -e -i <filename>
```

Decrypt a file: 

```
sops -d -i <filename>
```

Create an ssh key to use with github. You will need this for the next step if you don't already have one setup for github, more info here: 
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/checking-for-existing-ssh-keys

## Vyos setup

scp age key to folder from localhost: 

```bash
scp ~/.config/sops/age/age.key vyos@<ip>:/config/secrets/age.key
```

scp private github ssh key: 
```
scp ~/.ssh/<keyname> vyos@<ip>:/config/secrets
```

### Initialize git repo
This repo will be downloaded to /config and merged with the current contents. 

Check git global defaults, the preconfig bootscript should have set this, but you can check with the following: 
```
git config --list 
```

If needed, you can setup defaults: 
```
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git config --global init.defaultBranch main
git config --global --add safe.directory /config
```

Add git repo to the /config directory: 
```
cd /config
git init
git remote add origin git@github.com:<repo>.git
git pull
git checkout main -f
```

Apply configuration: 
```
configure
cd /config
./apply-config.sh (dry run by default, pass -c for commit) 
```

### Maintaining things moving forward
In true gitops fashion, all edits should be committed to git.

When you are ready to make a change, ssh to the router, cd to /config, git pull, then configure and run apply-config.sh (-c for commit, dry run is the default which is recommended first to see what will change)
