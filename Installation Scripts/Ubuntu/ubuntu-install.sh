#!/bin/bash

cd ~

#Updates the System
echo '(1/18) Update system...'
sudo apt update -yy

#Install gdebi and htop
sudo apt install -yy gdebi htop

#Installs MSFonts
echo '(9/18) Installing Fonts...'
sudo apt install -yy fonts-liberation fonts-linuxlibertine ttf-dejavu fonts-ubuntu-font-family-console 

wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb
sudo gdebi --n ttf-mscorefonts-installer_3.6_all.deb
rm ttf-mscorefonts-installer_3.6_all.deb

#Remove and Reinstall Docker
echo '(10/18) Installing new docker installation...'
sudo apt install -yy curl \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual
sudo apt install -yy apt-transport-https \
                       ca-certificates
curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add -

sudo add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"
sudo apt update -yy

sudo apt -y install docker-engine

#Create usergroup to access docker without sudo
echo '(11/18) Granting $USER right to user docker...'
sudo groupadd docker
sudo usermod -aG docker $USER

#If you want, uncomment this
#echo '(12/18) Start docker on boot...'
#sudo systemctl enable docker

echo '(13/18) Installing git and svn...'
sudo apt install -yy git subversion

#Downloads Java from the oracle page
sudo apt install -y default-jdk

#Installing Apache Maven
echo '(16/18) Installing maven...'
sudo apt install -yy maven

echo '(15/18) Downloading and installing Eclipse IDE...'
wget "http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/neon/2/eclipse-jee-neon-2-linux-gtk-x86_64.tar.gz"
echo 'Download completed.. Starting installation...'

tar xf eclipse-jee-neon-2-linux-gtk-x86_64.tar.gz
chown -R $USER:$USER eclipse
sudo ln -s /home/$USER/eclipse/eclipse /usr/local/bin/eclipse

rm eclipse-jee-neon-2-linux-gtk-x86_64.tar.gz

#Installing Skype for Linux ALPHA
sudo apt install apt-transport-https -y
curl https://repo.skype.com/data/SKYPE-GPG-KEY | sudo apt-key add -
echo "deb https://repo.skype.com/deb stable main" | sudo tee /etc/apt/sources.list.d/skypeforlinux.list
sudo apt update -y
sudo apt install skypeforlinux -y


echo "vm.swappiness = 10" | sudo tee /etc/sysctl.conf

echo '(18/18) Final Update and Clean-up...'
sudo apt update -yy

echo 'Everything done! Please reboot'

