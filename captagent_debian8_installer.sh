#/bin/bash

apt-get install sudo -y

#rajout du dépot contenant captagent
echo '# depot de debian strech on jessie' >> /etc/apt/sources.list && echo 'deb http://deb.debian.org/debian stretch main' >> /etc/apt/sources.list
sudo apt-get update -y && sudo apt-get upgrade -y

sudo apt search captagent
# 144kB of download, izi 
sudo apt show captagent
sudo apt-get install captagent -y

#on se place dans le dossier de configuration de captagent /etc/captagent
#mais comme ça peut varier j'ai adapté avec une commande spécifique
cd "$(dirname "$(find / -type f -name captagent.xml | head -1)")"
ls -al

#modify of the HEP conf file
sed -i.default 's/127.0.0.1/192.168.0.88/' transport_hep.xml
sed -i 's/9061/9060/' transport_hep.xml
read -p "Choose your capture-id :) : " cptId
sed -i "s/2001/$cptId/" transport_hep.xml

#modifiy of the socket_pcap conf file
sed -i.default '6 s/eth0/any/' socket_pcap.xml
sed -i '18 s/eth0/any/' spcket_pcap.xml

#Your defaults conf files are stored here. cautious guy
mkdir defaults
mv transport_hep.xml.default defaults/
mv socket_pcap.xml.default defaults/

#Restart the service and see his status
sudo service captagent restart && sudo service captagent status -l





