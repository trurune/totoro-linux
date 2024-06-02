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
	mkfs.ext4 $ROOTTOTOTORO
 	mkfs.fat -F32 $BOOTTOTORO
  	mount $ROOTTOTOTORO /mnt
   	mount $BOOTTOTOTORO /mnt/boot --mkdir
    	pacstrap -K /mnt linux linux-firmware base base-devel
     	wget https://raw.githubusercontent.com/nowcat123/toroto-linux/master/packages.txt -o /mnt/packages.txt
      	arch-chroot /mnt pacman -S - < packages.txt
     	bootctl install
fi
fi
