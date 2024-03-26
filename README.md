# AGX_Isaac_Prepare
This script prepares the Jetson AGX Xavier board from SEEED Studio with the necesary packages and libraries for Isaac-Ros.
This script takes into account that the board only has 32GB of memory, so for it to work it is necessary to connect an USB remobable device formated as ext4.

## How to use:
```
sudo apt update
sudo apt-get install -y dos2unix
git clone https://github.com/Martin-Reparaz/AGX_Isaac_Prepare.git
cd AGX_Isaac_Prepare
sudo dos2unix prepareAGX.sh
./prepareAGX.sh <USB_NAME>
```
$${\color{red}**As \space CUDNN \space requires \space of \space an \space authentication \space to \space download, \space make \space sure \space that \space the \space .deb \space file \space is \space in \space the \space /home/(user) \space directory \space before \space executing \space the \space script!**}$$

**As CUDNN requires of an authentication to download, make sure that the .deb file is in the `/home/<user>` directory before executing the script!**

**You can download CUDNN for your CUDA install by clicking [HERE](https://developer.nvidia.com/rdp/cudnn-download)**

## VNC Rep:
Also mention that, this script makes use of [dispChange](https://github.com/Martin-Reparaz/dispChange.git) repository to solve VNC connection errors that occurr in some vino versions.
