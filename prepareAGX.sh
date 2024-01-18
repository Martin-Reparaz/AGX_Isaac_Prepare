#!/bin/bash

#Color definitions echo -e
RED='\033[1;31m'       # ${RED}
YELLOW='\033[1;33m'    # ${YELLOW}
PURPLE='\033[1;35m'    # ${PURPLE}
GREEN='\033[1;32m'     # ${GREEN}
BLUE='\033[1;34m'      # ${BLUE}
CYAN='\033[1;36m'      # ${CYAN}
NC='\033[0m' #No color # ${NC}

### Actualizar paquetes ###
echo -e "${YELLOW}Updating packages...${NC}"
sudo apt upgrade -y
sudo apt update
sudo apt-get install -y nano

### Configuración VNC ###
echo -e "${YELLOW}Installing vino...${NC}"
cd /home/usuario
sudo apt install -y vino
echo -e "${YELLOW}Configuring vino server...${NC}"
cd /home/usuario
git clone https://github.com/Martin-Reparaz/dispChange.git
cd dispChange
chmod +x *
./conf_vnc_server.sh
# sudo ./dispMode.sh --vnc # Ejecutar este el ultimo, ya que requiere de reboot

### Instalación pip ###
echo -e "${YELLOW}Installing pip...${NC}"
cd /home/usuario
sudo apt-get install -y pip

### Instalación Jetson Stats ###
echo -e "${YELLOW}Installing Jetson-Stats...${NC}"
cd /home/usuario
sudo pip3 install jetson-stats
echo -e "${YELLOW}Initializing jtop service...${NC}"
sudo systemctl restart jtop.service # Es necesario realizar un reboot para que jtop funcione

### Instalación de CUDA y CUDNN ###
echo -e "${YELLOW}Installing CUDA...${NC}"
cd /home/usuario
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/sbsa/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.3.2/local_installers/cuda-repo-ubuntu2004-12-3-local_12.3.2-545.23.08-1_arm64.deb
sudo dpkg -i cuda-repo-ubuntu2004-12-3-local_12.3.2-545.23.08-1_arm64.deb
sudo cp /var/cuda-repo-ubuntu2004-12-3-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-3
# sudo apt-get install -y cuda-drivers
echo -e "${YELLOW}Installing CUDNN...${NC}"
echo -e "${RED}As for cudnn download authentification is required, please download the correct version from here https://developer.nvidia.com/rdp/cudnn-download ${NC}"
# echo -e "${RED}After download install it by using: sudo dpkg -i cudnn-local-repo-ubuntu2004-8.9.7.29_1.0-1_arm64.deb ${NC}"
# echo -e "${RED}And then: sudo cp /var/cudnn-local-repo-ubuntu2004-8.9.7.29/cudnn-local-7C47AFB9-keyring.gpg /usr/share/keyrings/ ${NC}"
# Ensure that the file was previously transfered to the board root directory
sudo dpkg -i cudnn-local-repo-ubuntu2004-8.9.7.29_1.0-1_arm64.deb
sudo cp /var/cudnn-local-repo-ubuntu2004-8.9.7.29/cudnn-local-7C47AFB9-keyring.gpg /usr/share/keyrings/

### Isaac ROS Buildfarm ###
echo -e "${YELLOW}Installing dependencies for Isaac Buildfarm...${NC}"
sudo apt update && sudo apt install gnupg wget
sudo apt install software-properties-common
sudo add-apt-repository universe
echo -e "${YELLOW}Setting up sources...${NC}"
wget -qO - https://isaac.download.nvidia.com/isaac-ros/repos.key | sudo apt-key add -
echo 'deb https://isaac.download.nvidia.com/isaac-ros/ubuntu/main focal main' | sudo tee -a /etc/apt/sources.list
sudo apt update
sudo apt-get upgrade -y
sudo apt-get install -y curl
sudo curl -sSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xF42ED6FBAB17C654" | sudo gpg --dearmor -o /usr/share/keyrings/ros-archive-keyring.gpg
# sudo apt update && sudo apt install curl -y \ && sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

### ROS2 PACKAGES INSTALL ###
echo -e "${YELLOW}Installing ROS2 packages...${NC}"
cd /home/usuario
sudo apt update
sudo apt install -y ros-humble-desktop-full
sudo apt install -y ros-dev-tools

### ISAAC ROS COMPUTE SETUP ###
echo -e "${YELLOW}Configuring Isaac Ros Compute setup...${NC}"
cd /home/usuario
sudo apt-get install -y nvidia-container
cat /etc/nv_tegra_release # Should be: Jetpack 5.1.2 & R35 (release), REVISION: 4.1
echo -e "${YELLOW}Setting the GPU and CPU clock to max...${NC}"
sudo /usr/bin/jetson_clocks
echo -e "${YELLOW}Setting the to power to MAX settings...${NC}"
sudo /usr/sbin/nvpmodel -m 0
echo -e "${YELLOW}Adding user to container group...${NC}"
sudo usermod -aG docker $USER
/usr/bin/newgrp docker << EONG
echo -e "${GREEN}Docker subshell started...${NC}"
newgrp docker
id
EONG

### SETTING UP THE DOCKER ###
echo -e "${YELLOW}Setting up the docker...${NC}"
cd /home/usuario
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt install docker-buildx-plugin

### PREPARING DOCKER TO WORK WITH USB REMOBABLE DEVICE ###
echo -e "${YELLOW}Modifying deault docker directory to work with USB...${NC}"
echo -e "${RED}For these steps USB must be connected!!${NC}"
cd /home/usuario
cd /var/lib
sudo rm -rf docker
cd /media/usuario/Martin
mkdir var && mkdir var/lib && mkdir var/lib/docker
cd /var/lib
sudo ln -s /media/usuario/Martin/var/lib/docker docker
sudo systemctl restart docker
echo -e "${CYAN}After boot it is possible that you´ll have to run docker daemon manually by using: sudo systemctl start docker${NC}"
docker info

### DEVELOPER ENVIRONMENT SETUP ###
echo -e "${YELLOW}Setting up developer environment...${NC}"
cd /home/usuario
echo -e "${YELLOW}Configuring the production repository...${NC}"
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo apt --fix-broken install -y
echo "Configuring docker..."
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
echo -e "${YELLOW}Configuring containerd...${NC}"
sudo nvidia-ctk runtime configure --runtime=containerd
sudo systemctl restart containerd

echo -e "${YELLOW}Restarting docker...${NC}"
sudo systemctl daemon-reload && sudo systemctl restart docker
echo -e "${YELLOW}Installing Git LFS...${NC}"
sudo apt-get install git-lfs
git lfs install --skip-repo

echo -e "${YELLOW}Creating ROS2 Workspace...${NC}"
mkdir -p  /media/usuario/Martin/workspaces/isaac_ros-dev/src
echo "export ISAAC_ROS_WS=/media/usuario/Martin/workspaces/isaac_ros-dev/" >> /home/usuario/.bashrc
source /home/usuario/.bashrc

### REBOOT BOARD ###
echo -e "${YELLOW}Applying display device configuration and booting board...${NC}"
cd /home/usuario/dispChange
sudo ./dispMode.sh --vnc