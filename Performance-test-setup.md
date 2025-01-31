# Pobrane pakiety:
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
- phoronix-test-suite - phoronix-test-suite
- pt_linux_x64 - pt_linux_x64
- IPMICFG_1.35.1_build.230912 - ipmicfg
- storcli
- ssh

# Passmark - pt_linux_x64
https://www.passmark.com/products/pt_linux/download.php

# Additional Performance Tests:
_pts installations always force downloading dependencies_    

phoronix-test-suite run build-linux-kernel     
phoronix-test-suite run c-ray    
phoronix-test-suite run compress-7zip    
phoronix-test-suite run gromacs-1.8.0    
phoronix-test-suite run namd-1.2.1

# Dysk
##     fio - flexible I/O tester:
        Kolejno: Sequential READ; Sequential WRITE; Random READ; Random READ-WRITE
        fio --name read --eta-newline=5s --rw=read --size=500m --io_size=10g --blocksize=1024k --ioengine=libaio --fsync=10000 --iodepth=32 --direct=1 --numjobs=1 --runtime=60 --group_reporting filename=/dev/nvme0n1
        fio --name write --eta-newline=5s --rw=write --size=500m --io_size=10g --blocksize=1024k --ioengine=libaio --fsync=10000 --iodepth=32 --direct=1 --numjobs=1 --runtime=60 --group_reporting filename=/dev/nvme0n1
        fio --name random-write --eta-newline=5s --rw=randread --size=500m --io_size=10g --blocksize=4k --ioengine=libaio --fsync=1 --iodepth=1 --direct=1 --numjobs=1 --runtime=60 --group_reporting filename=/dev/nvme0n1
        fio --name random-read --eta-newline=5s --rw=randrw --size=500m --io_size=10g --blocksize=4k --ioengine=libaio --fsync=1 --iodepth=1 --direct=1 --numjobs=1 --runtime=60 --group_reporting filename=/dev/nvme0n1

## Additional Storcli packets:
008.0011.0000.0014_Storcli2
Broadcom Limited Avenger MR 8.11 Storcli2
*******************************************
======================
Supported Controllers
==================
Avenger 9600-16e
Avenger 9600-8i8e
Avenger 9600-16i
Avenger 9600-24i
Avenger 9600w-16e
Avenger 9620-16i
Avenger 9660-16i
Avenger 9670W-16i
Avenger 9670-24i
README_STORCLI_SAS3.5_P33
Broadcom SAS3.5 StorCLI Utility
*********************************************************
Supported Controllers:
SAS3004
SAS3008
SAS3108_1
SAS3108_2
SAS3108_3
SAS3108_4
SAS3108_5
SAS3108_6
SAS3216
SAS3224
SAS3316_1
SAS3316_2
SAS3316_3
SAS3316_4
SAS3324_1
SAS3324_2
SAS3324_3
SAS3324_4
007.3103.0000.0000_MR 7.31_storcli
Broadcom Limited Aero MR 7.31 storcli
*******************************************
======================
Supported Controllers
==================
MegaRAID SAS 9540-2M2
MegaRAID SAS 9540-8i
MegaRAID SAS 9560-8i
MegaRAID SAS 9560-16i
MegaRAID SAS 9580-8i8e
MegaRAID SAS 9562-16i

_Reszta tych pakietów na ich stronie to do kontrolerów avenger, albo starsze wersje_
https://www.broadcom.com/support/download-search?dk=storcli
