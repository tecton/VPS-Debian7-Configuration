#!/bin/bash

cd /usr/src
wget -q ftp://ftp.infradead.org/pub/ocserv/ocserv-0.9.2.tar.xz && tar Jxvf ocserv-0.9.2.tar.xz;
cd ocserv-0.9.2;

echo "deb http://ftp.debian.org/debian wheezy-backports main contrib non-free" >> /etc/apt/sources.list;
apt-get update;
apt-get install -y build-essential pkg-config gnutls-bin;
apt-get -y -t wheezy-backports install libgnutls28-dev libpam0g-dev autogen libseccomp-dev libwrap0-dev libreadline-dev;
./configure --prefix=/usr --sysconfdir=/etc && make && make install;
cd

# generate CA certification
wget -q https://raw.githubusercontent.com/tecton/VPS-Debian7-Configuration/master/ca.tmpl && certtool --generate-privkey --outfile ca-key.pem;
certtool --generate-self-signed --load-privkey ca-key.pem --template ca.tmpl --outfile ca-cert.pem;

# generate local server cert
wget -q https://raw.githubusercontent.com/tecton/VPS-Debian7-Configuration/master/server.tmpl && certtool --generate-privkey --outfile server-key.pem;
certtool --generate-certificate --load-privkey server-key.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --template server.tmpl --outfile server-cert.pem;

# generate client cert
wget -q https://raw.githubusercontent.com/tecton/VPS-Debian7-Configuration/master/user.tmpl && certtool --generate-privkey --outfile user-key.pem;
certtool --generate-certificate --load-privkey user-key.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --template user.tmpl --outfile user-cert.pem;

# move cert file location
mv ca-cert.pem /etc/ssl/certs;
mv ca-key.pem /etc/ssl/private;
mv server-cert.pem /etc/ssl/certs;
mv server-key.pem /etc/ssl/private;

mkdir /etc/ocserv;
wget -q https://raw.githubusercontent.com/tecton/VPS-Debian7-Configuration/master/ocserv.conf -O /etc/ocserv/ocserv.conf &&
wget -q https://raw.githubusercontent.com/tecton/VPS-Debian7-Configuration/master/profile.xml -O /etc/ocserv/profile.xml;

# use plain text password
wget -q https://raw.githubusercontent.com/tecton/VPS-Debian7-Configuration/master/ocpasswd -O /etc/ocserv/ocpasswd;

wget -q https://raw.githubusercontent.com/tecton/VPS-Debian7-Configuration/master/sysctl.conf -O /etc/sysctl.conf && sysctl -p;

wget -q https://raw.githubusercontent.com/tecton/VPS-Debian7-Configuration/master/iptables.firewall.rules -O /etc/iptables.firewall.rules;
wget -q https://raw.githubusercontent.com/tecton/VPS-Debian7-Configuration/master/rc.local -O /etc/rc.local;
iptables-restore < /etc/iptables.firewall.rules;

wget -q https://raw.githubusercontent.com/tecton/VPS-Debian7-Configuration/master/ocserv -O /etc/init.d/ocserv && chmod 755 /etc/init.d/ocserv;
update-rc.d ocserv defaults && /etc/init.d/ocserv start;
reboot