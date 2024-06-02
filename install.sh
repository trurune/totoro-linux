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
	echo "Making Filesystems..."
	mkfs.ext4 $ROOTTOTOTORO
 	mkfs.fat -F32 $BOOTTOTORO
  	echo "DONE!"
  	echo "Mounting Filesystems..."
  	mount $ROOTTOTOTORO /mnt
   	mount $BOOTTOTOTORO /mnt/boot --mkdir
    	echo "DONE!"
     	echo "Installing Base System..."
    	pacstrap -K /mnt linux linux-firmware base base-devel
     	echo "Installing Extra Packages..."
     	wget https://raw.githubusercontent.com/nowcat123/toroto-linux/master/packages.txt -o /mnt/packages.txt
      	arch-chroot /mnt pacman -S - < packages.txt
       	echo "DONE!"
	echo "INSTALLING BOOTLOADER!"
     	arch-chroot /mnt bootctl install
      	echo "DONE!"
	echo "CONFIGURING BOOTLOADER!
fi
fi
