#!/bin/bash


wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb > /dev/null 2>&1
sudo apt-get -f install -y > /dev/null 2>&1
rm google-chrome-stable_current_amd64.deb

exit 0 # Success
