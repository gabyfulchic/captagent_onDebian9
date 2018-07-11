#!/bin/bash

number=$RANDOM

apt-get install sudo -y
sudo apt-get update -y && sudo apt-get upgrade -y

sudo apt-get install captagent -y

cd /etc/captagent/
ls -al

sed -i.default 's/127.0.0.1/192.168.0.88/' transport_hep.xml
mkdir defaults
mv transport_hep.xml.default defaults/

sed -i.trash 's/9061/9060/' transport_hep.xml
rm -rf transport_hep.xml.trash

sed -i.trash 's/2001/$number/' transport_hep.xml
rm -rf transport_hep.xml.trash

sed -i.default '6 s/eth0/any/' socket_pcap.xml
mv socket_pcap.xml.default defaults/

sed -i.trash '18 s/eth0/any/' socket_pcap.xml
rm -rf socket_pcap.xml.trash

cd /etc/default/
sed -i.old 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"/' grub
mkdir old
mv grub.old /old
sudo update-grub


