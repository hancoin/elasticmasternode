#!/bin/bash

##################################################
####install multi masternode with auto-update#####
##################################################
if [ "$1" == "-multi" ];then
printf "\033[0;37m################################################\033[0m\n" 
printf '\033[00;32mAutomatic installation for multi 3DCoin masternodes\033[0m\n'
printf "\033[0;37m################################################\033[0m\n" 
sleep 2
printf "\033[1;31mPlease enter your vps ip's: (Exemple:111.111.111.111 222.222.222.222 333.333.333.333)\033[0m\n"
read -p "IP HERE:" ip
printf '\033[1m\n'
sleep 2
yes | apt-get install sshpass
sleep 2
for i in $ip
do
ssh-keygen -f "/root/.ssh/known_hosts" -R $i
printf "\033[0;37m################################################\033[0m\n" 
printf '\033[00;32mVPS Connexion\033[0m' $i
printf "\n\033[0;37m################################################\033[0m\n" 
sleep 2
printf ''
read -p "PLEASE ENTER USER ROOT:" root
read -p "PLEASE ENTER PASSWORD ROOT:" rootpass
read -p "PLEASE ENTER RPC USER:" username
read -p "PLEASE ENTER RPC PASSWORD:" pass
read -p "PLEASE ENTER PRIVATEKEY MASTERNODE:" pv
printf '\n'
printf "\033[0;37m########################################\033[0m\n" 
sshpass -p $rootpass ssh -o StrictHostKeyChecking=no $root@$i '
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mInstall packages .....\033[0m\n" 
printf "\033[1;31m########################################\033[0m\n"
sleep 2 
yes | apt-get install ufw python virtualenv git unzip pv nano htop libwww-perl
yes | sudo apt-get update
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
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mDone - Firewall/Swapfile setup\033[0m\n"
printf "\033[1;31m########################################\033[0m\n"
sleep 4
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mBuilding 3dcoin core from source .....\033[0m\n" 
printf "\033[1;31m########################################\033[0m\n"
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
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mCompile 3dcoin core .....\033[0m\n"
printf "\033[1;31m########################################\033[0m\n"
sleep 4
printf "\033[00;32mStart .....\033[0m\n" 
sleep 4
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mAutogen .....\033[0m\n" 
printf "\033[1;31m########################################\033[0m\n"
cd 3dcoin
./autogen.sh
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mConfigure .....\033[0m\n" 
printf "\033[1;31m########################################\033[0m\n"
./configure --disable-tests --disable-gui-tests --without-gui
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mMake install 3DCoin core\033[0m\n"
printf "\033[1;31m########################################\033[0m\n"
make install
sleep 2
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mCompile 3dcoin core done\033[0m\n"
printf "\033[1;31m########################################\033[0m\n"
sleep 2
cd ~
mkdir ./.3dcoin
echo "#----
rpcuser="'$username'"
rpcpassword="'$pass'"
rpcallowip=127.0.0.1
#----
listen=1
server=1
daemon=1
maxconnections=64
#----
masternode=1
masternodeprivkey="'$pv'"
externalip="'$i'"
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
echo "#!/bin/bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
content=\$(GET https://raw.githubusercontent.com/BlockchainTechLLC/3dcoin/master/configure.ac)
localcontent=\$(cat /root/3dcoin/configure.ac)
if [ \"\$content\" == \"\$localcontent\" ];then
exit;
else
killall -9 3dcoind
rm /usr/local/bin/3dcoind
cd ~
cd /root/3dcoin
git pull
make install
fi" >> /usr/local/bin/update.sh
cd ~
cd /usr/local/bin
chmod 755 check.sh
chmod 755 update.sh
cd ~
line="@reboot /usr/local/bin/3dcoind
*/5 * * * * /usr/local/bin/check.sh
0 0 * * * /usr/local/bin/update.sh"
echo "$line" | crontab -u root -

sleep 2
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32m3DCoin core Instalation complete\033[0m\n"
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mMasternode start automatically after reboot\033[0m\n"
printf "\033[1;31m########################################\033[0m\n" 
sleep 4
reboot'
done

#############################################################
###only install auto update masternode or multi masternode###
#############################################################
elif [ "$1" == "-auto-update" ];then
printf "\033[0;37m#######################################################\033[0m\n" 
printf '\033[00;32mInstall auto update (check masternode & check update version)\033[0m\n'
printf "\033[0;37m#######################################################\033[0m\n" 
sleep 2
# choose auto update masternode or multi masternode
read -p "install auto update Masternode 3DCoin (Single vps) or Multi Masternode (Multi vps)? ( S/M )" -n 1 -r
echo    # (optional) move to a new line
# auto update masternode
if [[ $REPLY =~ ^[Ss]$ ]]; then
rm -f /usr/local/bin/check.sh
rm -f /usr/local/bin/update.sh
yes | sudo apt-get install libwww-perl
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
echo '#!/bin/bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
content=$(GET https://raw.githubusercontent.com/BlockchainTechLLC/3dcoin/master/configure.ac)
localcontent=$(cat /root/3dcoin/configure.ac)
if [ "$content" == "$localcontent" ];then
exit;
else
killall -9 3dcoind
rm /usr/local/bin/3dcoind
cd ~
cd /root/3dcoin
git pull
make install
fi' >> /usr/local/bin/update.sh
cd ~
cd /usr/local/bin
chmod 755 check.sh
chmod 755 update.sh
cd ~
export EDITOR=nano
crontab -r 
line="@reboot /usr/local/bin/3dcoind
*/5 * * * * /usr/local/bin/check.sh
0 0 * * * /usr/local/bin/update.sh"
echo "$line" | crontab -u root -
reboot
# auto update multi masternode
elif [[ $REPLY =~ ^[Mm]$ ]]; then
printf "\033[1;31mPlease enter ip vps: (Exemple:111.111.111.111 222.222.222.222 333.333.333.333)\033[0m\n"
read -p "IP HERE:" ip
printf '\033[1m\n'
sleep 2
yes | apt-get install sshpass
sleep 2
for i in $ip
do
ssh-keygen -f "/root/.ssh/known_hosts" -R $i
printf "\033[0;37m################################################\033[0m\n" 
printf '\033[00;32mVPS Connexion\033[0m' $i
printf "\n\033[0;37m################################################\033[0m\n" 
sleep 2
printf '\n'
read -p "PLEASE ENTER USER ROOT:" root
read -p "PLEASE ENTER PASSWORD ROOT:" rootpass
printf '\n'
printf "\033[0;37m########################################\033[0m\n" 
sshpass -p $rootpass ssh -o StrictHostKeyChecking=no $root@$i '
rm  -f /usr/local/bin/check.sh
rm  -f /usr/local/bin/update.sh
yes | sudo apt-get install libwww-perl
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
echo "#!/bin/bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
content=\$(GET https://raw.githubusercontent.com/BlockchainTechLLC/3dcoin/master/configure.ac)
localcontent=\$(cat /root/3dcoin/configure.ac)
if [ \"\$content\" == \"\$localcontent\" ];then
exit;
else
killall -9 3dcoind
rm /usr/local/bin/3dcoind
cd ~
cd /root/3dcoin
git pull
make install
fi" >> /usr/local/bin/update.sh
cd ~
cd /usr/local/bin
chmod 755 check.sh
chmod 755 update.sh
cd ~
crontab -r
line="@reboot /usr/local/bin/3dcoind
*/5 * * * * /usr/local/bin/check.sh
0 0 * * * /usr/local/bin/update.sh"
echo "$line" | crontab -u root -
reboot'
done
else
exit;
fi

################################################
###only update masternode or multi masternode###
################################################
elif [ "$1" == "-update" ];then
printf "\033[0;37m########################################\033[0m\n" 
printf '\033[00;32mUpdate masternode 3DCoin\033[0m\n'
printf "\033[0;37m########################################\033[0m\n" 
# update single masternode or multi masternode
read -p "Update Masternode 3DCoin (Single vps) or Multi Masternode (Multi vps)? ( S/M )" -n 1 -r
echo    # (optional) move to a new line
# update single masternode 
if [[ $REPLY =~ ^[Ss]$ ]]; then
killall -9 3dcoind
rm /usr/local/bin/3dcoind
cd ~
cd /root/3dcoin
git pull
make install
reboot
# update multi masternode
elif [[ $REPLY =~ ^[Mm]$ ]]; then
sleep 2
printf "\033[1;31mPlease enter ip vps: (Exemple:111.111.111.111 222.222.222.222 333.333.333.333)\033[0m\n"
read -p "IP HERE:" ip
printf '\033[1m\n'
sleep 2
yes | apt-get install sshpass
sleep 2
for i in $ip
do
ssh-keygen -f "/root/.ssh/known_hosts" -R $i
printf "\033[0;37m################################################\033[0m\n" 
printf '\033[00;32mVPS Connexion\033[0m' $i
printf "\n\033[0;37m################################################\033[0m\n" 
sleep 2
printf '\n'
read -p "PLEASE ENTER USER ROOT:" root
read -p "PLEASE ENTER PASSWORD ROOT:" rootpass
printf '\n'
printf "\033[0;37m########################################\033[0m\n" 
sshpass -p $rootpass ssh -o StrictHostKeyChecking=no $root@$i '
killall -9 3dcoind
rm /usr/local/bin/3dcoind
cd ~
cd /root/3dcoin
git pull
make install
reboot'
done
else
exit;
fi 
 
##################################################
#####install single masternode with auto-update###
##################################################
else
printf "\033[0;37m########################################\033[0m\n" 
printf '\033[00;32mAutomatic installation for 3DCoin masternode\033[0m\n'
printf "\033[0;37m########################################\033[0m\n" 
sleep 1
printf ''
read -p "PLEASE ENTER VPS IP:" ip
read -p "PLEASE ENTER RPC USER:" username
read -p "PLEASE ENTER RPC PASSWORD:" pass
read -p "PLEASE ENTER PRIVATEKEY MASTERNODE:" pv
printf ''
sleep 1
printf "\033[0;37m########################################\033[0m\n" 
sleep 2
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mInstall packages .....\033[0m\n" 
printf "\033[1;31m########################################\033[0m\n"
yes | apt-get install ufw python virtualenv git unzip pv nano htop libwww-perl
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
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mDone - Firewall/Swapfile setup\033[0m\n"
printf "\033[1;31m########################################\033[0m\n"
sleep 4
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mBuilding 3dcoin core from source .....\033[0m\n" 
printf "\033[1;31m########################################\033[0m\n"
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
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mCompile 3dcoin core .....\033[0m\n"
printf "\033[1;31m########################################\033[0m\n"
sleep 4
printf "\033[00;32mStart .....\033[0m\n" 
sleep 4
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mAutogen .....\033[0m\n" 
printf "\033[1;31m########################################\033[0m\n"
cd 3dcoin
./autogen.sh
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mConfigure .....\033[0m\n" 
printf "\033[1;31m########################################\033[0m\n"
./configure --disable-tests --disable-gui-tests --without-gui
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mMake install 3DCoin core\033[0m\n"
printf "\033[1;31m########################################\033[0m\n"
make install
sleep 2
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mCompile 3dcoin core done\033[0m\n"
printf "\033[1;31m########################################\033[0m\n"
sleep 2
cd ~
mkdir ./.3dcoin
echo "#----
rpcuser="$username"
rpcpassword="$pass"
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
echo '#!/bin/bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
content=$(GET https://raw.githubusercontent.com/BlockchainTechLLC/3dcoin/master/configure.ac)
localcontent=$(cat /root/3dcoin/configure.ac)
if [ "$content" == "$localcontent" ];then
exit;
else
killall -9 3dcoind
rm /usr/local/bin/3dcoind
cd ~
cd /root/3dcoin
git pull
make install
fi' >> /usr/local/bin/update.sh
cd ~
cd /usr/local/bin
chmod 755 check.sh
chmod 755 update.sh
cd ~
line="@reboot /usr/local/bin/3dcoind
*/5 * * * * /usr/local/bin/check.sh
0 0 * * * /usr/local/bin/update.sh"
echo "$line" | crontab -u root -

sleep 2
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32m3DCoin core Installation complete\033[0m\n"
printf "\033[1;31m########################################\033[0m\n"
printf "\033[00;32mMasternode start automatically after reboot\033[0m\n"
printf "\033[1;31m########################################\033[0m\n" 
sleep 4
reboot
fi