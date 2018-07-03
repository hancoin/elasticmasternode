#!/bin/bash
RED='\033[1;31m'
GREEN='\033[00;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
##################################################
####Install Multi Masternode with Auto-update#####
##################################################
if [ "$1" == "-multi" ];then
printf "${YELLOW}##################################################################${NC}\n" 
printf "${GREEN}Automatic installation for multi 3DCoin masternodes${NC}\n"
printf "${YELLOW}##################################################################${NC}\n" 
sleep 2
printf "Please enter your vps ip's: ${RED}(Exemple:111.111.111.111 222.222.222.222 333.333.333.333)${NC}\n"
read -p "IP HERE: " ip
printf "${YELLOW}################################################${NC}\n" 
read -p "Do you want to use the same rpcuser & rpcpass for all vps)? (Y/N)" -n 1 -r
echo    # (optional) move to a new line
printf "${YELLOW}################################################${NC}\n" 
if [[ $REPLY =~ ^[Yy]$ ]]; then
unset username
while [ -z ${username} ]; do
read -p "PLEASE ENTER RPC USER: " username
done
unset pass
while [ -z ${pass} ]; do
read -s -p "PLEASE ENTER RPC PASSWORD: " pass
done
printf "\n${YELLOW}################################################${NC}\n" 
yes | apt-get install sshpass
for i in $ip
do
printf "${YELLOW}################################################${NC}\n" 
printf "${GREEN}Data For Vps ip '${RED}$i${NC}${GREEN}'${NC}\n" 
printf "${YELLOW}################################################${NC}\n" 
unset rootpass
while [ -z ${rootpass} ]; do
read -s -p "Please Enter Password Root $i: " rootpass
done
printf "\n${YELLOW}################################################${NC}\n" 
PS3='Please enter your choice: '
options=("Install Masternode" "Install Node")
select opt in "${options[@]}"
do
    case $opt in
        "Install Masternode")
             break
           ;;
        "Install Node")
             break
           ;;
        *) echo invalid option;;
    esac
done
if [ "$opt" == "Install Masternode" ];then
unset pv
while [ -z ${pv} ]; do
read -p "Please Enter Masterbode Private key for $i: " pv
done
printf "${RED}Install Masternode Start .................................${NC}\n"
config="#----
\nrpcuser=\"'$username'\"
\nrpcpassword=\"'$pass'\"
\nrpcallowip=127.0.0.1
\n#----
\nlisten=1
\nserver=1
\ndaemon=1
\nmaxconnections=64
\n#----
\nmasternode=1
\nmasternodeprivkey=\"'$pv'\"
\nexternalip=\"'$i'\"
\n#----"
else
printf "${RED}Install Node Start .................................${NC}\n"
config="#----
\nrpcuser=\"'$username'\"
\nrpcpassword=\"'$pass'\"
\nrpcallowip=127.0.0.1
\n#----
\nlisten=1
\nserver=1
\ndaemon=1
\nmaxconnections=64
\n#----
\nexternalip=\"'$i'\"
\n#----"
fi
ssh-keygen -f "/root/.ssh/known_hosts" -R $i
printf "${YELLOW}################################################${NC}\n" 
printf "${GREEN}VPS Connexion '${RED}$i${NC}${GREEN}'${NC}\n" 
printf "${YELLOW}################################################${NC}\n" 
sshpass -p $rootpass ssh -o StrictHostKeyChecking=no root@$i '
echo "#!/bin/bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
configdata=\"'$config'\"
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
echo \"/swapfile none swap sw 0 0\" >> /etc/fstab
sleep 4
cd ~
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
cd 3dcoin
./autogen.sh
./configure --disable-tests --disable-gui-tests --without-gui
make install
sleep 2
cd ~
rm -f ./.3dcoin/3dcoin.conf
mkdir ./.3dcoin
echo -e \"\$configdata\" >> ./.3dcoin/3dcoin.conf
cd ~
echo \"#!/bin/bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
if ! ps -C 3dcoind > /dev/null
then
3dcoind
fi\" >> /usr/local/bin/check.sh
echo \"#!/bin/bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
content="\\$"\$(GET https://raw.githubusercontent.com/BlockchainTechLLC/3dcoin/master/configure.ac)
localcontent="\\$"\$(cat /root/3dcoin/configure.ac)
if [ "\\$"\""\\$"\$content"\\$"\" == "\\$"\""\\$"\$localcontent"\\$"\" ];then 
exit;
else
killall -9 3dcoind
rm -f /usr/local/bin/3dcoind
dir="\\$"\$(find / -type d -name "3dcoin" -print) 
cd "\\$"\$dir
git pull
make install || { ./autogen.sh && ./configure --disable-tests --disable-gui-tests --without-gui && make install;  }
3dcoind
fi\" >> /usr/local/bin/update.sh
cd ~
cd /usr/local/bin
chmod 755 check.sh
chmod 755 update.sh
cd ~
crontab -r
line=\"@reboot /usr/local/bin/3dcoind
*/15 * * * * /usr/local/bin/check.sh
0 0 * * * /usr/local/bin/update.sh\"
echo \"\$line\" | crontab -u root -
sleep 2
reboot" >> /root/install.sh
chmod 755 install.sh
line2="@reboot /root/install.sh"
echo "$line2" | crontab -u root -
reboot -p 3 
exit'

done
elif [[ $REPLY =~ ^[Nn]$ ]]; then
yes | apt-get install sshpass
for i in $ip
do
printf "${YELLOW}################################################${NC}\n" 
printf "${GREEN}Data For Vps ip '${RED}$i${NC}${GREEN}'${NC}\n" 
printf "${YELLOW}################################################${NC}\n" 
unset rootpass
while [ -z ${rootpass} ]; do
read -s -p "Please Enter Password Root $i: " rootpass
done
printf "\n${YELLOW}################################################${NC}\n" 
unset username
while [ -z ${username} ]; do
read -p "PLEASE ENTER RPC USER: " username
done
unset pass
while [ -z ${pass} ]; do
read -s -p "PLEASE ENTER RPC USER: " pass
done
printf "\n${YELLOW}################################################${NC}\n" 
PS3='Please enter your choice: '
options=("Install Masternode" "Install Node")
select opt in "${options[@]}"
do
    case $opt in
        "Install Masternode")
             break
           ;;
        "Install Node")
             break 
           ;;
        *) echo invalid option;;
    esac
done
if [ "$opt" == "Install Masternode" ];then
unset pv
while [ -z ${pv} ]; do
read -p "Please Enter Masterbode Private key for $i: " pv
done
printf "${RED}Install Masternode Start .................................${NC}\n"
config="#----
\nrpcuser=\"'$username'\"
\nrpcpassword=\"'$pass'\"
\nrpcallowip=127.0.0.1
\n#----
\nlisten=1
\nserver=1
\ndaemon=1
\nmaxconnections=64
\n#----
\nmasternode=1
\nmasternodeprivkey=\"'$pv'\"
\nexternalip=\"'$i'\"
\#----"
else
printf "${RED}Install Node Start .................................${NC}\n"
config="#----
\nrpcuser=\"'$username'\"
\nrpcpassword=\"'$pass'\"
\nrpcallowip=127.0.0.1
\n#----
\nlisten=1
\nserver=1
\ndaemon=1
\nmaxconnections=64
\n#----
\nexternalip=\"'$i'\"
\n#----"
fi
ssh-keygen -f "/root/.ssh/known_hosts" -R $i
printf "${YELLOW}################################################${NC}\n" 
printf "${GREEN}VPS Connexion '${RED}$i${NC}${GREEN}'${NC}\n" 
printf "${YELLOW}################################################${NC}\n" 
sshpass -p $rootpass ssh -o StrictHostKeyChecking=no root@$i '
echo "#!/bin/bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
configdata=\"'$config'\"
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
echo \"/swapfile none swap sw 0 0\" >> /etc/fstab
sleep 4
cd ~
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
cd 3dcoin
./autogen.sh
./configure --disable-tests --disable-gui-tests --without-gui
make install
sleep 2
cd ~
rm -f ./.3dcoin/3dcoin.conf
mkdir ./.3dcoin
echo -e \"\$configdata\" >> ./.3dcoin/3dcoin.conf
cd ~
echo \"#!/bin/bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
if ! ps -C 3dcoind > /dev/null
then
3dcoind
fi\" >> /usr/local/bin/check.sh
echo \"#!/bin/bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
content="\\$"\$(GET https://raw.githubusercontent.com/BlockchainTechLLC/3dcoin/master/configure.ac)
localcontent="\\$"\$(cat /root/3dcoin/configure.ac)
if [ "\\$"\""\\$"\$content"\\$"\" == "\\$"\""\\$"\$localcontent"\\$"\" ];then 
exit;
else
killall -9 3dcoind
rm -f /usr/local/bin/3dcoind
dir="\\$"\$(find / -type d -name "3dcoin" -print) 
cd "\\$"\$dir
git pull
make install || { ./autogen.sh && ./configure --disable-tests --disable-gui-tests --without-gui && make install;  }
3dcoind
fi\" >> /usr/local/bin/update.sh
cd ~
cd /usr/local/bin
chmod 755 check.sh
chmod 755 update.sh
cd ~
crontab -r
line=\"@reboot /usr/local/bin/3dcoind
*/15 * * * * /usr/local/bin/check.sh
0 0 * * * /usr/local/bin/source update.sh\"
echo \"\$line\" | crontab -u root -
sleep 2
reboot" >> /root/install.sh
chmod 755 install.sh
line2="@reboot /root/install.sh"
echo "$line2" | crontab -u root -
reboot -p 3 
exit'
done
else
exit;
fi

#############################################################
###only install auto update masternode or multi masternode###
#############################################################
elif [ "$1" == "-auto-update" ];then
printf "${YELLOW}#########################################################################${NC}\n" 
printf "${GREEN}Install auto update (check masternode & check update version)${NC}\n"
printf "${YELLOW}#########################################################################${NC}\n" 
sleep 2
# choose auto update masternode or multi masternode
read -p "install auto update Masternode 3DCoin (Single vps) or Multi Masternode (Multi vps)? (S/M)" -n 1 -r
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
echo "#!/bin/bash
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
content=\$(GET https://raw.githubusercontent.com/BlockchainTechLLC/3dcoin/master/configure.ac)
localcontent=\$(cat /root/3dcoin/configure.ac)
if [ '\$content' == '\$localcontent' ];then
exit;
else
killall -9 3dcoind
rm -f /usr/local/bin/3dcoind
dir=\$(find / -type d -name '3dcoin' -print) 
cd \$dir
git pull
make install || { ./autogen.sh && ./configure --disable-tests --disable-gui-tests --without-gui && make install;  }
3dcoind
fi" >> /usr/local/bin/update.sh
cd ~
cd /usr/local/bin
chmod 755 check.sh
chmod 755 update.sh
cd ~
export EDITOR=nano
crontab -r 
line="@reboot /usr/local/bin/3dcoind
*/15 * * * * /usr/local/bin/check.sh
0 0 * * * /usr/local/bin/source update.sh"
echo "$line" | crontab -u root -
service cron restart
# auto update multi masternode
elif [[ $REPLY =~ ^[Mm]$ ]]; then
printf "Please enter your vps ip's: ${RED}(Exemple:111.111.111.111 222.222.222.222 333.333.333.333)${NC}\n"
read -p "IP HERE:" ip
sleep 2
yes | apt-get install sshpass
sleep 2
for i in $ip
do
ssh-keygen -f "/root/.ssh/known_hosts" -R $i 
printf "${YELLOW}################################################${NC}\n" 
printf "${GREEN}VPS Connexion '${RED}$i${NC}${GREEN}'${NC}\n" 
printf "${YELLOW}################################################${NC}\n" 
unset rootpass
while [ -z ${rootpass} ]; do
read -s -p "PLEASE ENTER PASSWORD ROOT: " rootpass
done
printf "\n${YELLOW}########################################${NC}\n" 
sleep 2
sshpass -p $rootpass ssh -o StrictHostKeyChecking=no root@$i '
rm -f /usr/local/bin/check.sh
rm -f /usr/local/bin/update.sh
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
rm -f /usr/local/bin/3dcoind
dir=\$(find / -type d -name "3dcoin" -print) 
cd \$dir
git pull
make install || { ./autogen.sh && ./configure --disable-tests --disable-gui-tests --without-gui && make install;  }
3dcoind
fi" >> /usr/local/bin/update.sh
cd ~
cd /usr/local/bin
chmod 755 check.sh
chmod 755 update.sh
cd ~
crontab -r
line="@reboot /usr/local/bin/3dcoind
*/15 * * * * /usr/local/bin/check.sh
0 0 * * * /usr/local/bin/source update.sh"
echo "$line" | crontab -u root -
service cron restart'
done
else
exit;
fi

##################################################
#####install single masternode with auto-update###
##################################################
else
printf "${YELLOW}##################################################################${NC}\n" 
printf "${GREEN}Automatic installation for multi 3DCoin masternodes${NC}\n"
printf "${YELLOW}##################################################################${NC}\n" 
sleep 1
unset ip
while [ -z ${ip} ]; do
read -p "PLEASE ENTER VPS IP: " ip
done
unset username
while [ -z ${username} ]; do
read -p "PLEASE ENTER RPC USER: " username
done
unset pass
while [ -z ${pass} ]; do
read -s -p "PLEASE ENTER RPC PASSWORD: " pass
done
printf "\n${YELLOW}########################################${NC}\n" 

PS3="Please enter your choice: "
options=("Install Masternode" "Install Node")
select opt in "${options[@]}"
do
    case $opt in
        "Install Masternode")
             break
           ;;
        "Install Node")
             break
           ;;
        *) echo invalid option;;
    esac
done
if [ "$opt" == "Install Masternode" ];then
unset pv
while [ -z ${pv} ]; do
read -p "Please Enter Masterbode Private key: " pv
done
printf "${YELLOW}########################################${NC}\n" 
printf "${RED}Install Masternode Start .................................${NC}\n"
config="#----
rpcuser=$username
rpcpassword=$pass
rpcallowip=127.0.0.1
#----
listen=1
server=1
daemon=1
maxconnections=64
#----
masternode=1
masternodeprivkey=$pv
externalip=$ip
#----"
else
printf "${YELLOW}########################################${NC}\n" 
printf "${RED}Install Node Start .................................${NC}\n"
config="#----
rpcuser=$username
rpcpassword=$pass
rpcallowip=127.0.0.1
#----
listen=1
server=1
daemon=1
maxconnections=64
#----
externalip=$ip
#----"
fi
sleep 2
printf "${YELLOW}########################################${NC}\n"
printf "${GREEN}Install packages .....${NC}\n" 
printf "${YELLOW}########################################${NC}\n"
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
printf "${YELLOW}########################################${NC}\n"
printf "${GREEN}Done - Firewall/Swapfile setup${NC}\n"
printf "${YELLOW}########################################${NC}\n"
sleep 4
printf "${YELLOW}########################################${NC}\n"
printf "${GREEN}Building 3dcoin core from source .....${NC}\n" 
printf "${YELLOW}########################################${NC}\n"
sleep 2
cd ~
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
printf "${YELLOW}########################################${NC}\n"
printf "${GREEN}Compile 3dcoin core .....${NC}\n"
printf "${YELLOW}########################################${NC}\n"
sleep 4
printf "${GREEN}Start .....${NC}\n" 
sleep 4
printf "${YELLOW}########################################${NC}\n"
printf "${GREEN}Autogen .....${NC}\n" 
printf "${YELLOW}########################################${NC}\n"
cd 3dcoin
./autogen.sh
printf "${YELLOW}########################################${NC}\n"
printf "${GREEN}Configure .....${NC}\n" 
printf "${YELLOW}########################################${NC}\n"
./configure --disable-tests --disable-gui-tests --without-gui
printf "${YELLOW}########################################${NC}\n"
printf "${GREEN}Make install 3DCoin core${NC}\n"
printf "${YELLOW}########################################${NC}\n"
make install
sleep 2
printf "${YELLOW}########################################${NC}\n"
printf "${GREEN}Compile 3dcoin core done${NC}\n"
printf "${YELLOW}########################################${NC}\n"
sleep 2
cd ~
rm -f ./.3dcoin/3dcoin.conf
mkdir ./.3dcoin
echo "$config" >> ./.3dcoin/3dcoin.conf
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
dir=$(find / -type d -name "3dcoin" -print) 
cd $dir
git pull
make install || { ./autogen.sh && ./configure --disable-tests --disable-gui-tests --without-gui && make install;  }
3dcoind
fi' >> /usr/local/bin/update.sh
cd ~
cd /usr/local/bin
chmod 755 check.sh
chmod 755 update.sh
cd ~
line="@reboot /usr/local/bin/3dcoind
*/15 * * * * /usr/local/bin/check.sh
0 0 * * * /usr/local/bin/source update.sh"
echo "$line" | crontab -u root -

sleep 2
printf "${YELLOW}########################################${NC}\n"
printf "${GREEN}3DCoin core Installation complete${NC}\n"
printf "${YELLOW}########################################${NC}\n"
printf "${GREEN}Masternode start automatically after reboot${NC}\n"
printf "${YELLOW}########################################${NC}\n" 
sleep 4
reboot
fi
