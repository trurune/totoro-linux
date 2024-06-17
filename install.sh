clear
echo "Installing Totoro Linux Toronto 06.2024"
lsblk
echo "What is your root partition (/dev/XXXX)?"
read ROOTTOTORO
echo "What is your boot partition (/dev/XXXX)?"
read BOOTTOTORO
echo "What do you want your username to be?"
read USER
echo "Please pick a Totoro Version (gnome, suckless)"
read VER
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
   	if [ -z "$VER" ]
    	then
     	echo "You have not set your VERSION!"
      	else
 	else
  	echo "Are you sure you want to install Totoro Linux to $ROOTTOTORO? This is irreversible! (Type Y and press enter to confirm, press enter to cancel)"
   	read CONFIRM
   	if [ $CONFIRM == "Y" ]
    then
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
     	wget https://raw.githubusercontent.com/trurune/totoro-linux/master/gnome-packages.txt -o /mnt/packages.txt
      	wget https://raw.githubusercontent.com/trurune/totoro-linux/master/issue
       	mv issue /mnt/etc/issue
	wget https://raw.githubusercontent.com/trurune/totoro-linux/master/os-release
 	mv os-release /mnt/etc/os-release
      	arch-chroot /mnt pacman -S - < packages.txt
       	echo "DONE!"
	fi
 	if [ $VER == "suckless"]
  	then
   	echo "Installing suckless requires some packages to be compiled, please be aware that this may take a while depending on your machine's power"
	arch-chroot /mnt git clone https://git.suckless.org/dwm
 	arch-chroot /mnt make dwm
  	arch-chroot /mnt sudo make install dwm
	rm -rf dwm
 	echo "exec dwm" >> /mnt/home/$USER/.xinitrc
   	wget https://raw.githubusercontent.com/trurune/totoro-linux/master/gnome-packages.txt -o /mnt/packages.txt
      	wget https://raw.githubusercontent.com/trurune/totoro-linux/master/issue
       	mv issue /mnt/etc/issue
	wget https://raw.githubusercontent.com/trurune/totoro-linux/master/os-release
 	mv os-release /mnt/etc/os-release
      	arch-chroot /mn	t pacman -S - < packages.txt
       	echo "DONE!"
	fi
 	echo "INSTALLING BOOTLOADER!"
     	arch-chroot /mnt bootctl install
      	echo "DONE!"
      
       	echo "GENERATING FSTAB"
	genfstab /mnt > /mnt/etc/fstab
	echo "CONFIGURING BOOTLOADER!"
 	echo "title Totoro Linux Toronto" >> /mnt/boot/loader/entries/arch.conf
  	echo "linux /vmlinuz-linux" >> /mnt/boot/loader/entries/arch.conf
   	echo "initrd /initramfs-linux.img" >> /mnt/boot/loader/entries/arch.conf
    	echo "options root=$ROOTTOTORO rw" >> /mnt/boot/loader/entries/arch.conf
     	echo "" > /mnt/boot/loader/loader.conf
      	echo "timeout 3" >> /mnt/boot/loader/loader.conf
   	echo "default arch.conf" >> /mnt/boot/loader/loader.conf
    	echo "DONE!"
     	echo "BOOTLOADER CHECK!"
      	arch-chroot /mnt bootctl list
       	echo "DONE!"
     	echo "ENABLING DAEMONS!"
      	arch-chroot /mnt systemctl enable gdm
 	arch-chroot /mnt systemctl enable NetworkManager
  	echo "DONE"
   	echo "INSTALLATION COMPLETED! YOU CAN NOW SAFELY REBOOT YOUR COMPUTER!"
    	else
     	echo "Cancelled!"
      	fi

fi
fi
fi
fi
