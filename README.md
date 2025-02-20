Simple script for downloading basic, diagnostic and test programs:
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


To run **performance-test-setup.sh** (basic-setup.sh installed analogically) on live USB:
- lsblk
- sudo umount /dev/sdx (the third partition of the USB)
- sudo mount /dev/sdx /mnt
- cd /mnt/Scripts-main
- sudo chmod +x performance-test-setup.sh
- sudo ./performance-test-setup.sh

Provide password when needed.
