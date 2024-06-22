if timeout 5s ping -c 1 baeldung.com | grep -q '64 bytes from'; then
wget https://raw.githubusercontent.com/trurune/totoro-linux/master/install.sh
mv install.sh /root/install
chmod +x /root/install
/root/install
else
echo "No internet connection! Opening wifi helper"
echo Welcome to the Totoro Wifi Helper!
iwctl station list
echo "What is your wifi station called?"
read STATION
iwctl station $STATION get-networks
echo "What is your network called (SSID)"
read NETWORK
iwctl station $STATION connect $NETWORK
echo "If all is well, you should boot into the install script, if not, you made a typo or don't have wifi, if you have ethernet, plug in your ethernet and reboot"
sleep 3
/root/dl.sh
fi
