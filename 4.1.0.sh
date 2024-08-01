clear
echo "Installing Totoro Linux Aurora 08.2024"
sleep 2
clear
lsblk
echo "WARNING: Choosing the wrong disk may cause data loss!"
echo "What is your disk (/dev/xxx)?"
read DISK
if [[ $DISK =~ "nvme" ]]; then
    export ROOTTOTORO=${DISK}p2
    export BOOTTOTORO=${DISK}p1
else
    export ROOTTOTORO=${DISK}2
    export BOOTTOTORO=${DISK}1
fi
clear
echo "What do you want your username to be?"
read USER
clear
echo "Please pick a Totoro Version (gnome, suckless, xfce, plasma, blank)"
read VER
clear
if [ -z "$VER" ]; then
    echo "You have not set your VER!"
else
    if [ -z "$ROOTTOTORO" ]; then
        echo "You have not set your ROOTTOTORO!"
    else
        if [ -z "$BOOTTOTORO" ]; then
            echo "You have not set your BOOTTOTORO!"
        else        
            if [ -z "$USER" ]; then
                echo "You have not set your USERNAME! (password will be set later)"
            else
                echo "Are you sure you want to install Totoro Linux to $ROOTTOTORO? This is irreversible! (Type Y and press enter to confirm, press enter to cancel)"
                read CONFIRM
                if [ "$CONFIRM" == "Y" ]; then
                    clear
                    echo "DESTROYING OLD GPT"
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
                    clear
                    echo "MAKING FILESYSTEMS!"
                    mkfs.ext4 $ROOTTOTORO
                    mkfs.fat -F32 $BOOTTOTORO
                    echo "DONE!"
                    clear
                    echo "MOUNTING FILESYSTEMS!"
                    mount $ROOTTOTORO /mnt
                    mount $BOOTTOTORO /mnt/boot --mkdir
                    echo "DONE!"
                    clear
                    echo "INSTALLNG BASE SYSTEM!"
                    pacstrap -K /mnt linux linux-firmware base base-devel
                    echo "MAKING USER!"
                    arch-chroot /mnt useradd $USER
                    clear
                    echo "PLEASE SET A PASSWORD FOR THE USER!"
                    arch-chroot /mnt passwd $USER
                    mkdir /mnt/home/$USER
                    arch-chroot /mnt chown -R $USER:$USER /home/$USER
                    arch-chroot /mnt usermod -a -G wheel $USER
                    wget https://raw.githubusercontent.com/trurune/totoro-linux/master/sudoers
                    cat sudoers > /mnt/etc/sudoers
                    echo "DONE!"
                    clear
                    echo "INSTALLING EXTRA PACKAGES!"
                    if [ "$VER" == "gnome" ]; then
                        wget https://raw.githubusercontent.com/trurune/totoro-linux/master/gnome-packages.txt
                        mv gnome-packages.txt /mnt/packages.txt
                        wget https://raw.githubusercontent.com/trurune/totoro-linux/master/issue
                        mv issue /mnt/etc/issue
                        wget https://raw.githubusercontent.com/trurune/totoro-linux/master/os-release
                        mv os-release /mnt/etc/os-release
                        arch-chroot /mnt pacman -Sy gdm gnome gnome-extras kitty firefox networkmanager --noconfirm
                        echo "DONE!"
                    fi
                    if [ "$VER" == "suckless" ]; then
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
                    if [ "$VER" == "blank" ]; then
                        wget https://raw.githubusercontent.com/trurune/totoro-linux/master/issue
                        mv issue /mnt/etc/issue
                        wget https://raw.githubusercontent.com/trurune/totoro-linux/master/os-release
                        mv os-release /mnt/etc/os-release
                        arch-chroot /mnt pacman -S networkmanager --noconfirm
                    fi
                    if [ "$VER" == "xfce" ]; then
                        wget https://raw.githubusercontent.com/trurune/totoro-linux/master/xfce-packages.txt
                        mv xfce-packages.txt /mnt/packages.txt
                        wget https://raw.githubusercontent.com/trurune/totoro-linux/master/issue
                        mv issue /mnt/etc/issue
                        wget https://raw.githubusercontent.com/trurune/totoro-linux/master/os-release
                        mv os-release /mnt/etc/os-release
                        arch-chroot /mnt pacman -Sy xorg xfce4 kitty firefox networkmanager sddm --noconfirm
                        echo "DONE!"
                    fi
                    if [ "$VER" == "plasma" ]; then
                        wget https://raw.githubusercontent.com/trurune/totoro-linux/master/plasma-packages.txt
                        mv plasma-packages.txt /mnt/packages.txt
                        wget https://raw.githubusercontent.com/trurune/totoro-linux/master/issue
                        mv issue /mnt/etc/issue
                        wget https://raw.githubusercontent.com/trurune/totoro-linux/master/os-release
                        mv os-release /mnt/etc/os-release
                        arch-chroot /mnt pacman -Sy xorg plasma-desktop sddm firefox kitty networkmanager --noconfirm
                        echo "DONE!"
                    fi
                    echo "EFI STUB SETUP"
                    efibootmgr --create --disk $ROOTTOTORO --part 1 --label "Totoro Linux :3" --loader /vmlinuz-linux --unicode 'root='$ROOTTOTORO' rw initrd=\initramfs-linux.img'        
                    echo "DONE!"
                    clear
                    echo "GENERATING FSTAB"
                    genfstab /mnt >> /mnt/etc/fstab
                    echo "DONE"
                    clear
                    echo "ENABLING DAEMONS!"
                    if [ "$VER" == "gnome" ]; then
                        arch-chroot /mnt systemctl enable gdm
                    fi
                    clear
                    echo "GENERATING LOCALES"
                    echo "Please uncomment the line where your locale is (e.g en_US.UTF-8 UTF-8)"
                    read DJODJ
                    nano /mnt/etc/locale.gen
                    arch-chroot /mnt locale-gen
                    echo "DONE!"
                    clear
                    echo "SETTING TIME ZONE"
                    echo "What is your continent?"
                    ls /usr/share/zoneinfo
                    read CONTINENT
                    echo "What is your timezone in that continent (often capital city)"
                    ls /usr/share/zoneinfo/$CONTINENT
                    read ZONE
                    arch-chroot /mnt ln -sf /usr/share/zoneinfo/$CONTINENT/$ZONE /etc/localtime
                    echo "DONE!"

                    if [ "$VER" == "plasma" ]; then
                        arch-chroot /mnt systemctl enable sddm
                    fi
                    if [ "$VER" == "xfce" ]; then
                        arch-chroot /mnt systemctl enable sddm
                    fi
                    arch-chroot /mnt systemctl enable NetworkManager
                    echo "totoro-linux" > /mnt/etc/hostname
                    echo "DONE"
                    clear
                    if [ "$VER" == "suckless" ]; then
                        echo "Notes for suckless: You are using the suckless version, there is therefore no DM included, simply run startx after logging to enter your desktop :3"
                    fi

                    echo 'export PS1="\u \w$ "' >> /mnt/home/$USER/.bashrc

                    echo "INSTALLATION COMPLETED! REBOOTING IN 5 SECONDS..."
                    sleep 5
                    reboot
                else
                    echo "Cancelled!"
                fi
            fi
        fi
    fi
fi

