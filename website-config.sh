#!/bin/bash

apt-get -y install nginx git-core && wget -q https://raw.githubusercontent.com/tecton/VPS-Debian7-Configuration/master/tecton-website -O /etc/nginx/sites-enabled/tecton-website;
mkdir -p /home/tecton/www.tecton69.com/public;
chown tecton:www-data /home/tecton/www.tecton69.com;
chown tecton:www-data /home/tecton/www.tecton69.com/public;
chmod 775 /home/tecton/www.tecton69.com;
chmod 775 /home/tecton/www.tecton69.com/public;
usermod -a -G www-data tecton;
usermod -a -G www-data www-data;
service nginx restart;

adduser --system --group --shell /bin/bash --disabled-password git;
usermod -a -G www-data git;
su - git;
wget -q https://raw.githubusercontent.com/tecton/VPS-Debian7-Configuration/master/authorized_keys -O /home/git/git.pub;
cd ~;
PATH=$PATH:~/bin
mkdir -p ~/bin;
git clone git://github.com/sitaramc/gitolite;
gitolite/install -ln /home/git/bin;
gitolite setup -pk git.pub;
wget -qO- https://raw.github.com/creationix/nvm/master/install.sh | sh;
source .nvm/nvm.sh;
nvm install 0.10;
npm install -g hexo;