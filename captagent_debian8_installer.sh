#/bin/bash

apt-get install sudo -y

#update upgrade very long if source added
sudo apt-get update -y && sudo apt-get upgrade -y

#downloading and installing captagent method

#install dependancies
# sources : https://github.com/sipcapture/captagent/wiki/Installation
sudo apt-get install libexpat1-dev libcap-dev libpcap-dev libuv-dev libgcrypt11-dev libjson0-dev libtool automake make flex bison -y
if [ $? -ge 1 ];then
	echo "The download of the dependancies failed"
fi

#clone the capt6 project / compile it and install it
cd /usr/src
sudo apt-get install git -y
git clone https://github.com/sipcapture/captagent.git captagent
cd captagent

./build.sh
./configure
if [ $? -ge 1 ];then
	echo "You can't configure without all the dependancies ! "
	echo "Set up them manually if the script occur an issue try to install them ! "
fi


make && make install
if [ $? -ge 1 ];then
	echo "Make failure..."
fi

#On se place dans le dossier de configuration de captagent /usr/src/captagent/conf/
#mais comme ça peut varier j'ai adapté avec une commande spécifique
#cd "$(dirname "$(find / -type f -name captagent.xml | head -1)")"

echo "---------------------------------------------"
echo " Vos fichiers de configuration de captagent :"
echo "---------------------------------------------"

cd /usr/local/captagent/etc/captagent/ && ls -al


#modify of the HEP conf file
sed -i.default 's/127.0.0.1/192.168.0.88/' transport_hep.xml
sed -i 's/9061/9060/' transport_hep.xml
read -p "Choose your capture-id : " cptId
sed -i "s/2001/$cptId/" transport_hep.xml

#modifiy of the socket_pcap conf file at precised line
sed -i.default '6 s/eth0/any/' socket_pcap.xml
sed -i '18 s/eth0/any/' socket_pcap.xml

#Your defaults conf files are stored here. cautious guy
mkdir defaults
mv transport_hep.xml.default defaults/
mv socket_pcap.xml.default defaults/

#Restart the service and see his status
#sudo service captagent restart && sudo service captagent status -l

#test captagent
#captagent -h && captagent -v

#create the captagent service
#cp /usr/src/captagent/init/deb/jessie/captagent.service /etc/systemd/system
#chmod 700 /etc/systemd/system/captagent.service
#systemctl enable captagent.service
#reboot


