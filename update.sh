#!/bin/bash
################################################
###       only-update 3DCoin Masternode             ###
################################################
printf "\033[0;37m########################################\033[0m\n" 
printf '\033[00;32monly-update 3DCoin Masternode\033[0m\n'
printf "\033[0;37m########################################\033[0m\n" 
# update single masternode 
3dcoin-cli stop
echo "Please wait......."
sleep 10
rm /usr/local/bin/3dcoind
dir=$(find / -type d -name '3dcoin' -print) 
cd $dir
git checkout master
git pull
make install || { ./autogen.sh && ./configure --disable-tests --disable-gui-tests --without-gui && make install;  }
3dcoind
