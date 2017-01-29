#!/bin/bash

#Removes Gnome Desktop Group
yum -y groupremove gnome-desktop

#Installs XFCE Desktop Group
yum --enablerepo=epel -y groups install "Xfce" 
yum -y groupinstall X11
echo "exec /usr/bin/xfce4-session" >> ~/.xinitrc 
startx
