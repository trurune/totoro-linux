
# Totoro Linux
<img src="https://raw.githubusercontent.com/nowcat123/toroto-linux/master/toroto.png" height=200>

Totoro Linux is an arch based distribution designed to be sleek and also easy to install.

# INSTALLATION GUIDE

# THIS IS EXPERIMENTAL!

# MAKE SURE YOU ARE INSTALLING TO A UEFI SYSTEM! TOTORO DOES NOT SUPPORT MBR!

Step 1. Boot into an Arch Linux live environment from a USB or another medium. (You can obtain an ISO from here: https://archlinux.org/download/) \
Step 2. Use cfdisk or another tool to format your disk, create a boot partition of about 1 gigabyte of storage, set it's type to an EFI System Partition. Optionally add a swap partition (go to MAKING AND ENABLING SWAP) Make the rest of your device a root partition.\
Step 3 (no longer required on versions of the script later than v1.1.1b). Set your ENV Variables\
BOOTTOTORO to your boot partition (e.g /dev/sdXX)\
ROOTTOTORO to your root partition (e.g /dev/sdxx)\
USER to your desired username (e.g totoro)\
PSSWD to your desired password\
Step 4. Install prerequisites\
Simply run  ```pacman -Sy wget``` to install wget, used to download the script from the internet.\
Step 5. Download scrpt\
Run wget  ```https://raw.githubusercontent.com/trurune/totoro-linux/master/install.sh``` to download the script \
Step 6. Give the script desired permissions\
Run ```chmod +x install.sh``` to give the script permission to execute\
Step 7. Run the script\
Run ```./install.sh``` to install Totoro Linux\
Step 8. Reboot!
run ```reboot``` and unplug your USB stick, you are done!

# MAKING AND ENABLING SWAP
Step 1. Run ```mkswap /dev/sdXX```\
Step 2. Run ```swapon /dev/sdXX```\
Step 3. Done!
