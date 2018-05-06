# Masternode
3DCoin Masternode auto installer

****************************************
Automatic installation Single 3DCoin masternode
****************************************

```
curl -O https://raw.githubusercontent.com/BlockchainTechLLC/masternode/master/install.sh > install.sh
chmod 755 install.sh
./install.sh
```

* VPS IP: enter your VPS IP Address.
* RPC USER: enter any string of numbers or letters, no special characters allowed
* PASSWORD: enter any string of numbers or letters, no special characters allowed
* PRIVATEKEY MASTERNODE: this is the private key you generated from your wallet debug console.

# Update to last version:
```
curl -o- https://raw.githubusercontent.com/BlockchainTechLLC/masternode/master/update.sh | bash
```
