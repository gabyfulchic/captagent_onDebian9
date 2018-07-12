#!/bin/bash

apt-get install sudo -y
sudo apt-get update -y && sudo apt-get upgrade -y

sudo apt-get install captagent -y

cd /etc/captagent/
ls -al

#config files of captagent. socket_pcap to get the traffic with captagent
#and transport_hep to send this traffic to a sip analyzer and capture server

sed -i.default 's/127.0.0.1/192.168.0.88/' transport_hep.xml

#folder defaults is here if u want to keep the default conf ;)
mkdir defaults
mv transport_hep.xml.default defaults/

sed -i 's/9061/9060/' transport_hep.xml

#double quotes used to well translate the variable
read -p "Choose your capture-id : " cptId
sed -i "s/2001/$cptId/" transport_hep.xml

#here i modify the interface because on debian 9 your interfaces
#are named enp0sxxxx so eth0 will occur an error on captagent
sed -i.default '6 s/eth0/any/' socket_pcap.xml
mv socket_pcap.xml.default defaults/

sed -i '18 s/eth0/any/' socket_pcap.xml

#In debian 9, also called Stretch, your interfaces are named enp0sxxx
#but like captagent is only using eth interfaces you will need to change
#the GRUB_CMDLINE8LINUX variable to allow you to change their name
#in /etc/network/interfaces
#I can't sed that for you, because everyone have differents interfaces names
#and number. sorry :/

cd /etc/default/
sed -i.old 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"/' grub

#again i keep you a default grub file saved if never you don't trust me.
mkdir old
mv grub.old old/
sudo update-grub

#now i check for you the captagent service
sudo service captagent restart && sudo service captagent status -l

