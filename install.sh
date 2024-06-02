if [ -z "$DISK" ]
then
	echo "You have not set your DISK env variable!"
	echo "use export DISK=/dev/XXX"
else

fdisk $DISK
fdisk /dev/DEV<<EOF
n


+512M
t
5
1
n



w
EOF

mkfs.fat -F32 {$DISK}1
mkfs.ext4 {$DISK}2
fi
