sudo apt-get remove wolfram-engine scratch sonic-pi
sudo apt-get update
sudo apt-upgrade
sudo apt-get install python-pip python-setuptools python-dnspython python-argparse python-m2crypto ppp usb-modeswitch wvdial procmail
sudo pip install requests
sudo pip install centinel-dev==0.1.5.1
centinel-dev --sync
centinel-dev
cp otros/config.ini ~/.centinel/config.ini

