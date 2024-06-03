echo "Installing Totoro Linux London 06.2024"
if [ -z "$ROOTTOTORO" ]
then
	echo "You have not set your ROOTTOTORO env variable!"
	echo "use export ROOTTOTORO=/dev/XXXX"
else
if [ -z "$BOOTTOTORO" ]
then
	echo "You have not set your BOOTTOTORO env variable!"
	echo "use export BOOTTOTORO=/dev/XXXX"
else	
	if [ -z "$USER" ]
 	then
  	echo "You have not set your USERNAME env variable!"
	echo "use export USER=username"
 	else
  	if [ -z "$PSSWD" ]
   	then
    	echo "You have not set your PSSWD env variable!"
	echo "use export PSSWD=password"
 	else
	echo "Making Filesystems..."
	mkfs.ext4 $ROOTTOTORO
 	mkfs.fat -F32 $BOOTTOTORO
  	echo "DONE!"
  	echo "Mounting Filesystems..."
  	mount $ROOTTOTORO /mnt
   	mount $BOOTTOTORO /mnt/boot --mkdir
    	echo "DONE!"
     	echo "Installing Base System..."
    	pacstrap -K /mnt linux linux-firmware base base-devel
     	echo "MAKING USER"
 	arch-chroot /mnt useradd $USER
  	arch-chroot /mnt passwd $USER < $PSSWD
   	arch-chroot /mnt mkdir /home/{$USER}/
    	arch.chroot /mnt/home git clone https://github.com/nowcat123/toroto-linux.git
     	mkdir /mnt/home/$USER
     	mv /mnt/home/toroto-linux/* /mnt/home/$USER
	arch-chroot /mnt chown +R $USER:$USER /home/$USER
   	echo "DONE!"
     	echo "Installing Extra Packages..."
     	wget https://raw.githubusercontent.com/nowcat123/toroto-linux/master/packages.txt -o /mnt/packages.txt
      	arch-chroot /mnt pacman -S - < packages.txt
       	echo "DONE!"
	echo "INSTALLING BOOTLOADER!"
     	arch-chroot /mnt bootctl install
      	echo "DONE!"
       	echo "GENERATING FSTAB"
	genfstab /mnt > /mnt/etc/fstab
	echo "CONFIGURING BOOTLOADER!"
 	echo "title Totoro Linux London" >> /mnt/boot/loader/entries/arch.conf
  	echo "linux /vmlinuz-linuz" >> /mnt/boot/loader/entries/arch.conf
   	echo "initrd /initramfs-linux.img" >> /mnt/boot/loader/entries/arch.conf
    	echo "options root=$ROOTTOTORO rw" >> /mnt/boot/loader/entries/arch.conf
     	echo "" > /mnt/boot/loader/loader.conf
      	echo "timeout 3" >> /mnt/boot/loader/loader.conf
   	echo "default arch.conf" >> /mnt/boot/loader/loader.conf
    	echo "DONE!"
     	echo "Enabling Display Manager"
      	arch-chroot /mnt systemctl enable gdm
       	echo "DONE!"
	echo "Enabling Network Manager"
 	arch-chroot /mnt systemctl enable NetworkManager
  	echo "DONE"
   	echo "INSTALLATION COMPLETED! YOU CAN NOW SAFELY REBOOT YOUR COMPUTER!"
fi
fi
fi
fi

