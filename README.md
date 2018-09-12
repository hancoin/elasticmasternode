#Proof of Knowledge Elastic Masternode auto installer

****************************************
Automatic install One POK Elastic HAN/EMN Masternode 
****************************************

```
curl -O https://raw.githubusercontent.com/hancoin/elasticmasternode/master/install.sh > install.sh
bash install.sh
```

* VPS IP: enter your VPS IP Address.
* RPC USER: enter any string of numbers or letters, no special characters allowed
* PASSWORD: enter any string of numbers or letters, no special characters allowed
* PRIVATEKEY MASTERNODE: this is the private key you generated from your wallet debug console.

****************************************
Automatic install One Elastic Masternode masternode
****************************************
```
curl -O https://raw.githubusercontent.com/Hancoin/elasticmasternode/master/install.sh > install.sh
bash install.sh -multi
```
* local host and/or IP'S: enter your local host and/or VPS IP'S Address (Exemple:666.666.666.666.666.1.777.666.666.666).
* RPC USER: enter any string of numbers or letters, no special characters allowed.
* RPC PASSWORD: enter any string of numbers or letters, no special characters allowed.
* LOCALHOST PASSWORD: enter your localhost password.
* PRIVATEKEY ELASTICMASTERNODE: this is the private key you generated from your wallet debug console.

****************************************
Install Auto Update & Auto check Masternode
****************************************
```
curl -O https://raw.githubusercontent.com/Hancoin/elasticmasternode/master/install.sh > install.sh
bash install.sh -auto-update
```

# Update to last version:
```
curl -o- https://raw.githubusercontent.com/Hancoin/elasticmasternode/master/update.sh | bash
```
