#!/bin/sh
echo "\033[0;37m########################################\033[0;37m" 
echo '\033[00;32mAutomatic installation masternode 3DCoin\033[00;32m'
echo "\033[0;37m########################################\033[0;37m" 
sleep 1
echo ''
ip=$(hostname -i)
read -p "PLEASE ENTER RPC USER:" username
read -p "PLEASE ENTER RPC PASSWORD:" rootpass
read -p "PLEASE ENTER PRIVATEKEY MASTERNODE:" pv
echo ''
sleep 1
echo "\033[0;37m########################################\033[0;37m" 
sleep 2

echo "\033[1;31m########################################\033[0m"
echo "\033[00;32mInstall packages .....\033[00;32m" 
echo "\033[1;31m########################################\033[0m"
yes | apt-get install ufw python virtualenv git unzip pv nano htop
yes | apt-get update
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp 
sudo ufw allow 6695/tcp
sudo ufw logging on 
yes | sudo ufw enable 
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile 
sudo swapon /swapfile
echo "/swapfile none swap sw 0 0" >> /etc/fstab
sleep 2 
echo "\033[1;31m########################################\033[0m"
echo "\033[00;32mDone - Swapfile \033[00;32m"
echo "\033[1;31m########################################\033[0m"
sleep 4
echo "\033[1;31m########################################\033[0m"
echo "\033[00;32mGit 3dcoin core .....\033[00;32m" 
echo "\033[1;31m########################################\033[0m"
sleep 2
sudo git clone https://github.com/BlockchainTechLLC/3dcoin.git
yes | sudo apt-get update 
export LC_ALL=en_US.UTF-8
yes | sudo apt-get install build-essential libtool autotools-dev autoconf automake autogen pkg-config libgtk-3-dev libssl-dev libevent-dev bsdmainutils
yes | sudo apt-get install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
yes | sudo apt-get install software-properties-common 
yes | sudo add-apt-repository ppa:bitcoin/bitcoin 
yes | sudo apt-get update 
yes | sudo apt-get install libdb4.8-dev libdb4.8++-dev 
yes | sudo apt-get install libminiupnpc-dev 
yes | sudo apt-get install libzmq3-dev
sleep 2
echo "\033[1;31m########################################\033[0m"
echo "\033[00;32mCompile 3dcoin core .....\033[00;32m"
echo "\033[1;31m########################################\033[0m"
sleep 4
echo "\033[00;32mStart .....\033[00;32m" 
sleep 4
echo "\033[1;31m########################################\033[0m"
echo "\033[00;32mAutogen .....\033[00;32m" 
echo "\033[1;31m########################################\033[0m"
cd 3dcoin
./autogen.sh
echo "\033[1;31m########################################\033[0m"
echo "\033[00;32mConfigure .....\033[00;32m" 
echo "\033[1;31m########################################\033[0m"
./configure --disable-tests --disable-gui-tests --without-gui
echo "\033[1;31m########################################\033[0m"
echo "\033[00;32mMake install 3DCoin core\033[00;32m"
echo "\033[1;31m########################################\033[0m"
make install
sleep 2
echo "\033[1;31m########################################\033[0m"
echo "\033[00;32mCompile 3dcoin core done\033[00;32m"
echo "\033[1;31m########################################\033[0m"
sleep 2
cd ~
mkdir ./.3dcoin
echo "#----
rpcuser="$username"
rpcpassword="$rootpass"
rpcallowip=127.0.0.1
#----
listen=1
server=1
daemon=1
maxconnections=64
#----
masternode=1
masternodeprivkey="$pv"
externalip="$ip"
#----" >> ./.3dcoin/3dcoin.conf
cd ~
echo "#!/bin/bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
if ! ps -C 3dcoind > /dev/null
then
3dcoind
fi" >> /usr/local/bin/check.sh
cd ~
cd /usr/local/bin
chmod 755 check.sh
cd ~
line="*/1 * * * * /usr/local/bin/check.sh"
echo "$line" | crontab -u root -

sleep 2
echo "\033[1;31m########################################\033[0m"
echo "\033[00;32m3DCoin core Instalation complete\033[00;32m"
echo "\033[1;31m########################################\033[0m"
echo "\033[00;32mMasternode start automatically after reboot\033[00;32m"
echo "\033[1;31m########################################\033[0m" 
sleep 4
reboot
