#!/bin/bash

#Run Script as sudo with your username as first parameter
#e.g. sudo sh centos-install.sh $USER
USER=$1
cd /home/$USER

#Updates the System
echo '(1/18) Update system...'
yum update -yy

# Adds Nux Repos to fix Fontrendering
echo '(2/18) Installing epel-release repository...'
yum -y install epel-release 
yum -y install http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm

echo '(3/18) Adds Nux Repos to fix Fontrendering...'
yum makecache fast

# Echoes font config
echo '(4/18) Create font config...'
echo -e '<?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
     <match target="font">
      <edit mode="assign" name="hinting" >
       <bool>true</bool>
      </edit>
     </match>
     <match target="font" >
      <edit mode="assign" name="autohint" >
       <bool>true</bool>
      </edit>
     </match>
     <match target="font">
      <edit mode="assign" name="hintstyle" >
      <const>hintslight</const>
      </edit>
     </match>
     <match target="font">
      <edit mode="assign" name="rgba" >
       <const>rgb</const>
      </edit>
     </match>
     <match target="font">
      <edit mode="assign" name="antialias" >
       <bool>true</bool>
      </edit>
     </match>
     <match target="font">
       <edit mode="assign" name="lcdfilter">
       <const>lcddefault</const>
       </edit>
     </match>
</fontconfig>' >> .fonts.conf

echo '(5/18) Changing Owner of fonts.conf to $USER...'
chown -v centos ~/.fonts.conf

#Enables Font Fixes
echo '(6/18) Enable font fixes...'
yum --enablerepo=nux-dextop install -yy fontconfig-infinality
yum --enablerepo=nux-dextop install -yy cairo
yum --enablerepo=nux-dextop install -yy libXft
yum --enablerepo=nux-dextop install -yy freetype-infinality

echo '(7/18) Installing additional Icon Themes...'
yum --enablerepo=nux-dextop install -yy faience-icon-theme

#Needed to Work with NTFS USB Drives
echo '(8/18) Installing ntfs packages...'
yum install -yy ntfs*

#Installs MSFonts
echo '(9/18) Installing MS Fonts...'
yum install -yy curl cabextract xorg-x11-font-utils fontconfig
rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

#Remove and Reinstall Docker
echo '(10/18) Removing old docker installation...'
yum remove -yy docker
yum remove -yy docker-selinux
rm -r /var/lib/docker

echo '(10/18) Installing new docker installation...'
yum install -yy yum-utils
yum-config-manager \
    --add-repo \
    https://docs.docker.com/engine/installation/linux/repo_files/centos/docker.repo
yum makecache fast
yum install -yy docker-engine

#Create usergroup to access docker without sudo
echo '(11/18) Granting $USER right to user docker...'
groupadd docker
usermod -aG docker $USER

echo '(12/18) Start docker on boot...'
systemctl enable docker

echo '(13/18) Installing git...'
yum install -yy git

echo '(14/18) Installing svn...'
yum install -yy svn

#Downloading and Installing Eclipse for Java EE
echo '(15/18) Downloading and installing Eclipse IDE...'
wget "http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/neon/2/eclipse-jee-neon-2-linux-gtk-x86_64.tar.gz"
echo 'Download completed.. Starting installation...'

tar xf eclipse-jee-neon-2-linux-gtk-x86_64.tar.gz
chown -R $USER:$USER eclipse-jee-neon-2-linux-gtk-x86_64
rm eclipse-jee-neon-2-linux-gtk-x86_64

#Installing Apache Maven
echo '(16/18) Installing maven...'
yum install -yy maven

#Installing Skype for Linux ALPHA
echo '(17/18) Downloading and installing skype for linux alpha...'
wget "https://go.skype.com/skypeforlinux-64-alpha.rpm"
yum localinstall -yy skypeforlinux-64-alpha.rpm

#Removes installed .rpm files
rm -f skypeforlinux-64-alpha.rpm

echo '(18/18) Final Update and Clean-up...'
yum update -yy

yum clean all

echo 'Everything done! Please reboot'

