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
fi
