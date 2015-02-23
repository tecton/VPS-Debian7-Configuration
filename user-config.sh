#!/bin/bash

adduser --disabled-password tecton
wget -q https://raw.githubusercontent.com/tecton/VPS-Debian7-Configuration/master/sudoers -O /etc/sudoers

# configure ssh to allow RSA and disable password login
mkdir /home/tecton/.ssh
wget -q https://raw.githubusercontent.com/tecton/VPS-Debian7-Configuration/master/sshd_config -O /etc/ssh/sshd_config
wget -q https://raw.githubusercontent.com/tecton/VPS-Debian7-Configuration/master/authorized_keys -O /home/tecton/.ssh/authorized_keys
sleep 1
chown -hR tecton /home/tecton/.ssh
/etc/init.d/ssh restart
passwd tecton
