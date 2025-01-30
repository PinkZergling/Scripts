#!/bin/bash

# Update and upgrade system
echo "Fetching the latest version of the package list..."
sudo apt update
sudo apt-get update

# Install essential programs
echo "Installing essential programs..."
ESSENTIAL_PROGRAMS=("curl" "wget" "htop" "nvme-cli" "fio" "stress")
for program in "${ESSENTIAL_PROGRAMS[@]}"; do
    sudo apt install -y "$program"
done

sudo wget -P /home https://www.supermicro.com/Bios/sw_download/642/IPMICFG_1.35.1_build.230912.zip
sudo mkdir /home/ipmicfg && sudo unzip /home/IPMICFG_1.35.1_build.230912.zip -d /home/ipmicfg

# Install and enable SSH
echo "Installing and enabling SSH..."
sudo apt install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

# Allow root login via SSH (with a password)
echo "Configuring SSH for root login with a password..."
SSH_CONFIG_FILE="/etc/ssh/sshd_config"
sudo sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' "$SSH_CONFIG_FILE"
sudo sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' "$SSH_CONFIG_FILE"
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' "$SSH_CONFIG_FILE"
sudo systemctl restart ssh

# Set root password
echo "Setting root password..."
echo "Enter the new password for root:"
sudo passwd root

# Display SSH service status
echo "SSH service status:"
sudo systemctl status ssh

echo "Disabling plasma-powerdevil.service"
systemctl --user stop plasma-powerdevil.service

echo -e "\nSkrypt wykonany.  :D"


for i in {1..2}; do
    echo
done


read -p "Czy chcesz wyswietlic przykladowe polecenia diagnostyczne? (Y/n)" zgoda
if [[ "$zgoda" == "n" || "$zgoda" == "N" ]]; then 
    exit 0
fi
N_CORES=$(nproc)

printf  "Polecenia diagnostyczne (wiekszosc wymaga sudo):
\033[1;35Narzedzia do sprawdzania dyskow:\033[0m
    lsblk - list block devices
    nvme  - the NVMe storage command line interface utility (nvme-cli):
        - nvme-list
    hdparm - get/set SATA/IDE device parameters
        - hdparm -Tt /dev/sdx
    fio - flexible I/O tester:
        Kolejno: Sequential READ; Sequential WRITE; Random READ; Random READ-WRITE
        fio --name TEST --eta-newline=5s --rw=read --size=500m --io_size=10g --blocksize=1024k --ioengine=libaio --fsync=10000 --iodepth=32 --direct=1 --numjobs=1 --runtime=60 --group_reporting filename=/dev/nvme0n1
        fio --name TEST --eta-newline=5s --rw=write --size=500m --io_size=10g --blocksize=1024k --ioengine=libaio --fsync=10000 --iodepth=32 --direct=1 --numjobs=1 --runtime=60 --group_reporting filename=/dev/nvme0n1
        fio --name TEST --eta-newline=5s --rw=randread --size=500m --io_size=10g --blocksize=4k --ioengine=libaio --fsync=1 --iodepth=1 --direct=1 --numjobs=1 --runtime=60 --group_reporting filename=/dev/nvme0n1
        fio --name TEST --eta-newline=5s --rw=randrw --size=500m --io_size=10g --blocksize=4k --ioengine=libaio --fsync=1 --iodepth=1 --direct=1 --numjobs=1 --runtime=60 --group_reporting filename=/dev/nvme0n1
\033[1;35Czyszczenie dysków:\033[0m    
    dd if=/dev/zero of=/dev/sdX bs=1M status=progress
    dd if=/dev/urandom of=/dev/sdX bs=1M status=progress
\033[1;35Stress testing:\033[0m
    stress --cpu $N_CORES --io 4 --vm 2 --vmbytes 128M
        $N_CORES - to rzeczywista liczba rdzeni w tym komputerze

\033[1;35Monitorowanie:\033[0m
    htop
    ipmicfg - narzędzie do IPMI - w /home/ipmicfg
    "
