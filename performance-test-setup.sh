#!/bin/bash

# Adding additional repositories
echo "deb http://security.ubuntu.com/ubuntu focal-security main universe" | sudo tee /etc/apt/sources.list.d/ubuntu-focal-sources.list

# Update and upgrade system
echo "Updating and upgarding the system..."
sudo apt update && sudo apt upgrade -y


# Install essential programs
echo "Installing essential programs..."
ESSENTIAL_PROGRAMS=("curl" "wget" "vim" "htop" "nvme-cli" "fio" "stress" "php" "php-gd" "php-dom" "php-simplexml" "unzip" "python3-pip" "s-tui" "linux-tools-common" "linux-tools-generic" "libncurses5" "bzip2" "openssh-server" "php8.3-xml" "sqlite3")
for program in "${ESSENTIAL_PROGRAMS[@]}"; do
    sudo apt install -y "$program"
done
# Phoronix
sudo wget -P /home https://github.com/phoronix-test-suite/phoronix-test-suite/archive/refs/heads/master.zip
sudo mkdir /home/phoronix-test-suite-master && sudo unzip /home/master.zip -d /home/phoronix-test-suite-master
cd /home/phoronix-test-suite-master/phoronix-test-suite-master && sudo chmod +x install-sh 
sudo ./install.sh
cd /home

# Passmark
sudo wget -P /home https://www.passmark.com/downloads/pt_linux_x64.zip
sudo mkdir /home/pt_linux && sudo unzip /home/pt_linux_x64.zip -d /home/pt_linux
sudo chmod +x /home/pt_linux/PerformanceTest/pt_linux_x64
sudo ln -s /home/pt_linux/PerformanceTest/pt_linux_x64 /usr/local/bin/pt_linux_x64

# IPMICFG
sudo wget -P /home https://www.supermicro.com/Bios/sw_download/642/IPMICFG_1.35.1_build.230912.zip
sudo mkdir /home/ipmicfg && sudo unzip /home/IPMICFG_1.35.1_build.230912.zip -d /home/ipmicfg
sudo chmod +x /home/ipmicfg/IPMICFG_1.35.1_build.230912/Linux/64bit/IPMICFG-Linux.x86_64
sudo ln -s /home/ipmicfg/IPMICFG_1.35.1_build.230912/Linux/64bit/IPMICFG-Linux.x86_64 /usr/local/bin/ipmicfg


# storcli
sudo wget -P /home https://docs.broadcom.com/docs-and-downloads/007.3103.0000.0000_MR%207.31_storcli.zip
sudo mkdir /home/storcli && sudo unzip '007.3103.0000.0000_MR 7.31_storcli.zip' -d /home/storcli
sudo unzip /home/storcli/storcli_rel/Unified_storcli_all_os.zip -d /home/storcli
sudo dpkg -i /home/storcli/Unified_storcli_all_os/Ubuntu/storcli_007.3103.0000.0000_all.deb
sudo ln -s /opt/MegaRAID/storcli/storcli64 /usr/bin/storcli

# Install and enable SSH
echo "Configuring SSH..."
sudo systemctl enable --now ssh

# Allow root login via SSH (with a password)
echo "Configuring SSH for root login with a password..."
SSH_CONFIG_FILE="/etc/ssh/sshd_config"
sudo sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' "$SSH_CONFIG_FILE"
sudo sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' "$SSH_CONFIG_FILE"
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' "$SSH_CONFIG_FILE"
sudo sshd -t && sudo systemctl restart ssh


echo "Disabling plasma-powerdevil.service"
systemctl --user stop plasma-powerdevil.service
systemctl --user mask plasma-powerdevil.service

# Set root password
echo "Setting root password..."
echo "Enter the new password for root:"
sudo passwd root

# Display SSH service status
echo "SSH service status:"
sudo systemctl status ssh


echo -e "\nScript execution completed! 😃"



for i in {1..2}; do
    echo
done


read -p "Do You want to display help? (Y/n)" zgoda
if [[ "$zgoda" == "n" || "$zgoda" == "N" ]]; then 
    exit 0
fi
N_CORES=$(nproc)


printf  "
Downloaded packets (Globally usable):
- curl
- wget 
- vim
- htop
- nvme-cli
- fio
- stress
- php
- unzip
- python3
- s-tui
- phoronix-test-suite 
- pt_linux_x64 
- ipmicfg
- storcli
- ssh

Polecenia diagnostyczne:
\033[1;35Narzedzia do sprawdzania dyskow:\033[0m
    lsblk
    nvme (nvme-cli):
        - nvme-list
    hdparm - get/set SATA/IDE device parameters
        - hdparm -Tt /dev/sdx
\033[1;35Czyszczenie dysków:\033[0m    
    dd if=/dev/zero of=/dev/sdX bs=1M status=progress
    dd if=/dev/urandom of=/dev/sdX bs=1M status=progress
\033[1;35Stress testing:\033[0m
    stress --cpu $N_CORES --io 4 --vm 2 --vmbytes 128M
        $N_CORES - to rzeczywista liczba rdzeni w tym komputerze

\033[1;35Monitorowanie:\033[0m
    htop
    ipmicfg - 
\033[1;35Wiecej informacji znajdziesz w Performance-test-setup.md\033[0m    
    "
