#!/bin/bash
################################################
###       only-update ElasticMasternode             ###
################################################
printf "\033[0;37m########################################\033[0m\n" 
printf '\033[00;32monly-update ElasticMasternode\033[0m\n'
printf "\033[0;37m########################################\033[0m\n" 
# update single masternode 
3dcoin-cli stop
echo "Please wait......."
sleep 10
rm /usr/local/bin/elasticmasternoded
dir=$(find / -type d -name 'elasticmasternode' -print) 
cd $dir
git checkout master
git pull
make install || { ./autogen.sh && ./configure --disable-tests --disable-gui-tests --without-gui && make install;  }
elasticmasternoded
