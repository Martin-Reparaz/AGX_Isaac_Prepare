# AGX_Isaac_Prepare
This script prepares the Jetson AGX board from SEEED Studio with the necesary packages and libraries for Isaac-Ros.
This script takes into account that the board only has 32GB of memory, so for it to work it is necessary to connect an USB remobable device formated as ext4.

## How to use:
```
git clone https://github.com/Martin-Reparaz/AGX_Isaac_Prepare.git
cd AGX_Isaac_Prepare
sudo ./prepareAGX.sh <USB_NAME>
```
**As CUDNN requires of an authentication to download, make sure that the .deb file is in the `/home/<user>` directory before executing the script!**
