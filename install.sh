#!/bin/bash

# default after install update

sudo apt update
sudo apt -y upgrade

# standard tools, they may be needed in the process, so install them first

sudo apt install -y software-properties-common curl git gitk

# steam needs 32bit architecture

sudo dpkg --add-architecture i386
sudo add-apt-repository multiverse
sudo apt update
sudo apt dist-upgrade

# install nodejs and npm

sudo apt install -y nodejs npm
sudo npm install -g n
sudo n latest

# install global servers for one-liners (see .bashrc)

sudo npm i -g http-server
sudo npm i -g ngrok

# install packages not from ubuntu repositories

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb

sudo add-apt-repository -y ppa:mscore-ubuntu/mscore3-stable
sudo apt update
sudo apt install -y musescore3

wget https://go.skype.com/skypeforlinux-64.deb
sudo apt install -y ./skypeforlinux-64.deb

wget https://downloads.slack-edge.com/releases/linux/4.22.0/prod/x64/slack-desktop-4.22.0-amd64.deb
sudo apt install -y ./slack-desktop-4.22.0-amd64.deb

sudo apt install -y libglib2.0-dev libgranite-dev libindicator3-dev libwingpanel-dev indicator-application
wget https://github.com/Lafydev/wingpanel-indicator-ayatana/raw/master/com.github.lafydev.wingpanel-indicator-ayatana_2.0.8_odin.deb
sudo apt install -y ./com.github.lafydev.wingpanel-indicator-ayatana_2.0.8_odin.deb

# install packages from standard repositories

sudo apt install -y firefox vim transmission libreoffice simple-scan darktable gimp inkscape audacity texlive-full gummi virtualbox steam blender vlc ruby-full ruby-bundler preload snapd

# telegram is always outdated, so install it as snap package for faster upgrades

sudo snap install telegram-desktop

# return compress/extract options to the context menu in files (bug?)

sudo apt install -y --reinstall org.gnome.fileroller

# clean the launcher

echo 'NoDisplay=true' | sudo tee -a /usr/share/applications/debian-xterm.desktop
echo 'NoDisplay=true' | sudo tee -a /usr/share/applications/debian-uxterm.desktop
echo 'NoDisplay=true' | sudo tee -a /usr/share/applications/display-im6.q16.desktop
echo 'NoDisplay=true' | sudo tee -a /usr/share/applications/org.pwmt.zathura.desktop

sudo sed -i 's/^NoDisplay=false/NoDisplay=true/' /usr/share/applications/libreoffice-startcenter.desktop

printf "\n\n\nRUN POST-INSTALL SCRIPT NOW (WITHOUT SUDO).\n\n\n";

