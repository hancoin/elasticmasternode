# Masternode
3DCoin Masternode auto installer

****************************************
Automatic install Single 3DCoin masternode
****************************************

```
curl -O https://raw.githubusercontent.com/BlockchainTechLLC/masternode/master/install.sh > install.sh
bash install.sh
```

* VPS IP: enter your VPS IP Address.
* RPC USER: enter any string of numbers or letters, no special characters allowed
* PASSWORD: enter any string of numbers or letters, no special characters allowed
* PRIVATEKEY MASTERNODE: this is the private key you generated from your wallet debug console.

****************************************
Automatic install Multi 3DCoin masternode
****************************************
```
curl -O https://raw.githubusercontent.com/BlockchainTechLLC/masternode/master/install.sh > install.sh
bash install.sh -multi
```
* VPS IP'S: enter your VPS IP'S Address (Exemple:111.111.111.111 222.222.222.222 333.333.333.333).
* RPC USER: enter any string of numbers or letters, no special characters allowed.
* RPC PASSWORD: enter any string of numbers or letters, no special characters allowed.
* VPS PASSWORD: enter your vps password.
* PRIVATEKEY MASTERNODE: this is the private key you generated from your wallet debug console.

****************************************
Install Auto Update & Auto check Masternode
****************************************
```
curl -O https://raw.githubusercontent.com/BlockchainTechLLC/masternode/master/install.sh > install.sh
bash install.sh -auto-update
```

# Update to last version:
```
curl -o- https://raw.githubusercontent.com/BlockchainTechLLC/masternode/master/update.sh | bash
```
