clear
echo "Installing Totoro Linux Dandelion 6.0.0"
sleep 2
clear

fdisk -l

echo "WARNING: Choosing the wrong disk may cause data loss!"
echo -n "Enter your disk (/dev/xxx): "
read DISK

if [[ $DISK =~ "nvme" ]]; then
    ROOTTOTORO="${DISK}p2"
    BOOTTOTORO="${DISK}p1"
else
    ROOTTOTORO="${DISK}2"
    BOOTTOTORO="${DISK}1"
fi

clear
echo -n "Enter your desired username: "
read USER

clear
echo "Available Totoro Versions: gnome, suckless, xfce, plasma, lxqt, mate, cinnamon, i3, deepin, blank"
echo -n "Select a Totoro Version: "
read VER

clear

if [[ -z "$VER" || -z "$ROOTTOTORO" || -z "$BOOTTOTORO" || -z "$USER" ]]; then
    echo "Error: Missing necessary information."
    exit 1
fi

echo "Are you sure you want to install Totoro Linux to $ROOTTOTORO? This is irreversible!"
echo -n "(Type Y and press enter to confirm, press enter to cancel): "
read CONFIRM

if [[ "$CONFIRM" != "Y" ]]; then
    echo "Installation cancelled!"
    exit 0
fi

clear

echo "Destroying old GPT..."
dd if=/dev/zero of=$DISK bs=512M status=progress count=1

echo "Creating new partitions..."
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

clear
echo "Creating filesystems..."
mkfs.ext4 $ROOTTOTORO
mkfs.fat -F32 $BOOTTOTORO
echo "Done!"

clear
echo "Mounting filesystems..."
mount $ROOTTOTORO /mnt
mount $BOOTTOTORO /mnt/boot --mkdir
echo "Done!"

clear
echo "Installing base system..."
pacstrap -K /mnt linux linux-firmware base base-devel
echo "Done!"

echo "Creating user..."
arch-chroot /mnt useradd $USER
clear
echo "Please set a password for the user."
arch-chroot /mnt passwd $USER

mkdir /mnt/home/$USER
arch-chroot /mnt chown -R $USER:$USER /home/$USER
arch-chroot /mnt usermod -a -G wheel $USER

wget -q https://raw.githubusercontent.com/trurune/totoro-linux/master/sudoers -O /mnt/etc/sudoers
echo "Done!"

clear
echo "Installing additional packages..."

case "$VER" in
    gnome)
        arch-chroot /mnt pacman -Sy gdm gnome gnome-extras kitty firefox networkmanager --noconfirm
        ;;
    suckless)
        echo "exec dwm" >> /mnt/home/$USER/.xinitrc
        wget -q "https://raw.githubusercontent.com/trurune/totoro-linux/master/suckless-packages.txt" -O /mnt/packages.txt
        wget -q https://raw.githubusercontent.com/trurune/totoro-linux/master/issue -O /mnt/etc/issue
        wget -q https://raw.githubusercontent.com/trurune/totoro-linux/master/os-release -O /mnt/etc/os-release
        arch-chroot /mnt pacman -S - < /mnt/packages.txt --noconfirm
        arch-chroot /mnt git clone https://git.suckless.org/dwm
        wget -q https://raw.githubusercontent.com/trurune/totoro-linux/master/config.h -O /mnt/dwm/config.h
        arch-chroot /mnt make -C dwm
        arch-chroot /mnt sudo make install -C dwm
        rm -rf /mnt/dwm
        arch-chroot /mnt git clone https://git.suckless.org/st
        arch-chroot /mnt make -C st
        arch-chroot /mnt sudo make install -C st
        rm -rf /mnt/st
        arch-chroot /mnt git clone https://git.suckless.org/dmenu
        arch-chroot /mnt make -C dmenu
        arch-chroot /mnt sudo make install -C dmenu
        rm -rf /mnt/dmenu
        ;;
    blank)
        arch-chroot /mnt pacman -S networkmanager --noconfirm
        ;;
    xfce)
        arch-chroot /mnt pacman -Sy xorg xfce4 kitty firefox networkmanager sddm --noconfirm
        ;;
    plasma)
        arch-chroot /mnt pacman -Sy xorg plasma-desktop sddm firefox kitty networkmanager --noconfirm
        ;;
    lxqt)
        arch-chroot /mnt pacman -Sy xorg lxqt networkmanager breeze-icons sddm firefox --noconfirm
        ;;
    mate)
        arch-chroot /mnt pacman -Sy xorg mate mate-extra lightdm lightdm-gtk-greeter firefox networkmanager --noconfirm
        ;;
    cinnamon)
        arch-chroot /mnt pacman -Sy xorg cinnamon lightdm lightdm-gtk-greeter firefox networkmanager --noconfirm
        ;;
    i3)
        arch-chroot /mnt pacman -Sy xorg i3 lightdm lightdm-gtk-greeter firefox networkmanager --noconfirm
        ;;
    deepin)
        arch-chroot /mnt pacman -Sy xorg deepin lightdm lightdm-gtk-greeter firefox networkmanager --noconfirm
        ;;
    *)
        echo "Invalid version selected."
        exit 1
        ;;
esac

echo "EFI Stub Setup"
efibootmgr --create --disk $ROOTTOTORO --part 1 --label "Totoro Linux :3" --loader /vmlinuz-linux --unicode "root=$ROOTTOTORO rw initrd=\initramfs-linux.img"        
echo "Done!"

clear
echo "Generating fstab..."
genfstab /mnt >> /mnt/etc/fstab
echo "Done!"

clear
echo "Enabling necessary services..."
[[ "$VER" == "gnome" ]] && arch-chroot /mnt systemctl enable gdm
[[ "$VER" == "suckless" ]] && echo "Reminder: No display manager in suckless version. Use startx to start the desktop."
[[ "$VER" =~ "plasma|xfce|lxqt|mate|cinnamon|i3|deepin" ]] && arch-chroot /mnt systemctl enable lightdm
arch-chroot /mnt systemctl enable NetworkManager
echo "totoro-linux" > /mnt/etc/hostname
echo "Done!"

clear
echo "Generating locales..."
echo "Please uncomment your locale in /mnt/etc/locale.gen (e.g., en_US.UTF-8 UTF-8)"
read -p "Press enter to continue..." _
nano /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "Done!"

clear
echo "Setting time zone..."
ls /usr/share/zoneinfo
echo -n "Enter your continent: "
read CONTINENT
ls /usr/share/zoneinfo/$CONTINENT
echo -n "Enter your time zone (e.g., capital city): "
read ZONE
arch-chroot /mnt ln -sf /usr/share/zoneinfo/$CONTINENT/$ZONE /etc/localtime
echo "Done!"

clear
echo 'export PS1="\u \w$ "' >> /mnt/home/$USER/.bashrc

echo "Installation completed! Rebooting in 5 seconds..."
sleep 5
reboot

