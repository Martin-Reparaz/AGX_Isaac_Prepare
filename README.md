# AGX_Isaac_Prepare
This script prepares the Jetson AGX board from SEEED Studio with the necesary packages and libraries for Isaac-Ros.
This script takes into account that the board only has 32GB of memory, so for it to work it is necessary to connect an USB remobable device formated as ext4.

## How to use:
```
git clone https://github.com/Martin-Reparaz/AGX_Isaac_Prepare.git
cd AGX_Isaac_Prepare
./prepareAGX.sh <USB_NAME>
```
**As CUDNN requires of an authentication to download, make sure that the .deb file is in the `/home/<user>` directory before executing the script!**

**You can download CUDNN for your CUDA install by clicking [HERE](https://developer.nvidia.com/rdp/cudnn-download)**

## VNC Rep:
Also mention that, this script makes use of [dispChange](https://github.com/Martin-Reparaz/dispChange.git) repository to solve VNC connection errors that occurr in some vino versions.
