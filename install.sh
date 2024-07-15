clear
echo "Installing Totoro Linux Osaka 06.2024"
lsblk
echo "What is your disk (/dev/XXX)?"
read DISK
if [[ $string =~ "nvme" ]]; then
export ROOTTOTORO=${DISK}p2
export BOOTTOTORO=${DISK}p1
else
export ROOTTOTORO=${DISK}2
export BOOTTOTORO=${DISK}1
fi
echo "What do you want your username to be?"
read USER
echo "Please pick a Totoro Version (gnome, suckless, xfce, blank)"
read VER
if [ -z VER ]
then
echo "You have not set your VER!"

else
if [ -z "$ROOTTOTORO" ]
then
	echo "You have not set your ROOTTOTORO!"

else
if [ -z "$BOOTTOTORO" ]
then
	echo "You have not set your BOOTTOTORO!"

else	
	if [ -z "$USER" ]
 	then
  	echo "You have not set your USERNAME! (password will be set later)"
   	else
  	echo "Are you sure you want to install Totoro Linux to $ROOTTOTORO? This is irreversible! (Type Y and press enter to confirm, press enter to cancel)"
   	read CONFIRM
   	if [ $CONFIRM == "Y" ]
    then
    	dd if=/dev/zero of=$DISK bs=512M status=progress count=1
	(
	echo g
 	echo n
  	echo 1
   	echo  
   	echo +512M
    	echo t
     	echo 1
      	echo n
       	echo 2
	echo  
 	echo  
  	echo w
) | sudo fdisk $DISK
	echo "MAKING FILESYSTEMS!"
	mkfs.ext4 $ROOTTOTORO
 	mkfs.fat -F32 $BOOTTOTORO
  	echo "DONE!"
  	echo "MOUNTING FILESYSTEMS!"
  	mount $ROOTTOTORO /mnt
   	mount $BOOTTOTORO /mnt/boot --mkdir
    	echo "DONE!"
     	echo "INSTALLNG BASE SYSTEM!"
    	pacstrap -K /mnt linux linux-firmware base base-devel
     	echo "MAKING USER!"
 	arch-chroot /mnt useradd $USER
  	echo "PLEASE SET A PASSWORD FOR THE USER!"
  	arch-chroot /mnt passwd $USER
   	mkdir /mnt/home/$USER
	arch-chroot /mnt chown -R $USER:$USER /home/$USER
 	arch-chroot /mnt usermod -a -G wheel alex
  	wget https://raw.githubusercontent.com/trurune/totoro-linux/master/sudoers
   	cat sudoers > /mnt/etc/sudoers
   	echo "DONE!"
     	echo "INSTALLING EXTRA PACKAGES!"
      	if [ $VER == "gnome" ]
	then
     	wget https://raw.githubusercontent.com/trurune/totoro-linux/master/gnome-packages.txt
      	mv gnome-packages.txt /mnt/packages.txt
      	wget https://raw.githubusercontent.com/trurune/totoro-linux/master/issue
       	mv issue /mnt/etc/issue
	wget https://raw.githubusercontent.com/trurune/totoro-linux/master/os-release
 	mv os-release /mnt/etc/os-release
      	arch-chroot /mnt pacman -S - < /mnt/packages.txt --noconfirm
       	echo "DONE!"
	fi
 	if [ $VER == "suckless" ]
  	then
   	
 	echo "exec dwm" >> /mnt/home/$USER/.xinitrc
   	wget https://raw.githubusercontent.com/trurune/totoro-linux/master/suckless-packages.txt
    	mv suckless-packages.txt /mnt/packages.txt
      	wget https://raw.githubusercontent.com/trurune/totoro-linux/master/issue
       	mv issue /mnt/etc/issue
	wget https://raw.githubusercontent.com/trurune/totoro-linux/master/os-release
 	mv os-release /mnt/etc/os-release
      	arch-chroot /mnt pacman -S - < /mnt/packages.txt --noconfirm
       	echo "Installing suckless requires some packages to be compiled, please be aware that this may take a while depending on your machine's power"
	arch-chroot /mnt git clone https://git.suckless.org/dwm
 	wget https://raw.githubusercontent.com/trurune/totoro-linux/master/config.h
  	mv config.h /mnt/dwm/config.h
 	arch-chroot /mnt make -C dwm
  	arch-chroot /mnt sudo make install -C dwm
	rm -rf dwm
	arch-chroot /mnt git clone https://git.suckless.org/st
 	arch-chroot /mnt make -C st
  	arch-chroot /mnt sudo make install -C st
   	rm -rf st
    	arch-chroot /mnt git clone https://git.suckless.org/dmenu
 	arch-chroot /mnt make -C dmenu
  	arch-chroot /mnt sudo make install -C dmenu
   	rm -rf dmenu
 echo "DONE!"
	fi
	if [ $VER == "blank" ]
	then
	arch-chroot /mnt pacman -S networkmanager --noconfirm
 	if [ $VER == "xfce" ]
	then
     	wget https://raw.githubusercontent.com/trurune/totoro-linux/master/xfce-packages.txt
      	mv xfce-packages.txt /mnt/packages.txt
      	wget https://raw.githubusercontent.com/trurune/totoro-linux/master/issue
       	mv issue /mnt/etc/issue
	wget https://raw.githubusercontent.com/trurune/totoro-linux/master/os-release
 	mv os-release /mnt/etc/os-release
      	arch-chroot /mnt pacman -S - < /mnt/packages.txt --noconfirm
       	echo "DONE!"
	fi
 	echo "EFI STUB SETUP"
		efibootmgr --create --disk $ROOTTOTORO --part 1 --label "Totoro Linux :3" --loader /vmlinuz-linux --unicode 'root=$ROOTTOTORO rw initrd=\initramfs-linux.img'
		
     	echo "DONE!"
     	echo "ENABLING DAEMONS!"
      	if [ $VER == "gnome" ]
        then
      	arch-chroot /mnt systemctl enable gdm
       	fi
	if [ $VER == "xfce" ]
 	then
  	arch-chroot /mnt systemctl enable sddm
   	fi
 	arch-chroot /mnt systemctl enable NetworkManager
  	echo "totoro-linux" > /mnt/etc/hostname
  	echo "DONE"
   	echo "INSTALLATION COMPLETED! YOU CAN NOW SAFELY REBOOT YOUR COMPUTER!"
    	if [ $VER == "suckless" ]
     	then
      	echo "You are using the suckless version, there is therefore no DM included, simply run startx after logging to enter your desktop :3"
       	fi
    	else
     	echo "Cancelled!"
      	fi
fi
fi
fi
fi
