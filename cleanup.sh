#!/usr/bin/env bash

# COLOR VARIABLES DECLARATION
COLOR_RED='\033[0;31m'

NO_COLOR='\033[0m'

echo -e "${COLOR_RED} Be patient, we are performing some household!${NO_COLOR}"

if [ "$(uname)" != "Darwin" ]; then
  echo -e "${COLOR_RED} So sorry! This script only supports MacOS currently.${NO_COLOR}"
  exit
fi

trap ctrl_c INT

function ctrl_c() {
  echo "Exit!"
  exit
}

# Ask for the administrator password upfront
if [ "$EUID" -ne 0  ]; then
  sudo -v
fi

echo 'Empty the Trash on all mounted volumes and the main HDD...'
sudo rm -rfv /Volumes/*/.Trashes &>/dev/null
sudo rm -rfv ~/.Trash &>/dev/null

echo 'Clear System Log Files...'
sudo rm -rfv /private/var/log/asl/*.asl &>/dev/null
sudo rm -rfv /Library/Logs/DiagnosticReports/* &>/dev/null
sudo rm -rfv /Library/Logs/Adobe/* &>/dev/null
rm -rfv ~/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/* &>/dev/null
rm -rfv ~/Library/Logs/CoreSimulator/* &>/dev/null

echo 'Clear zcompdump'
rm ~/.zcompdump*

echo 'Clear Adobe Cache Files...'
sudo rm -rfv ~/Library/Application\ Support/Adobe/Common/Media\ Cache\ Files/* &>/dev/null

echo 'Cleanup iOS Applications...'
rm -rfv ~/Music/iTunes/iTunes\ Media/Mobile\ Applications/* &>/dev/null

echo 'Remove iOS Device Backups...'
rm -rfv ~/Library/Application\ Support/MobileSync/Backup/* &>/dev/null

echo 'Cleanup XCode Derived Data and Archives...'
rm -rfv ~/Library/Developer/Xcode/DerivedData/* &>/dev/null
rm -rfv ~/Library/Developer/Xcode/Archives/* &>/dev/null

#user cache file
echo "cleaning user cache file from ~/Library/Caches"
rm -rf ~/Library/Caches/*

#user logs
echo "cleaning user log file from ~/Library/logs"
rm -rf ~/Library/logs/*
#user preference log
echo "cleaning user preference logs"
#rm -rf ~/Library/Preferences/*
echo "done cleaning from /Library/Preferences"
#system caches
echo "cleaning system caches"
sudo rm -rf /Library/Caches/*
echo "done cleaning system cache"
#system logs
echo "cleaning system logs from /Library/logs"
sudo rm -rf /Library/logs/*
echo "done cleaning from /Library/logs"
echo "cleaning system logs from /var/log"
sudo rm -rf /var/log/*
echo "done cleaning from /var/log"
echo "cleaning from /private/var/folders"
sudo rm -rf /private/var/folders/*
echo "done cleaning from /private/var/folders"
#ios photo caches
echo "cleaning ios photo caches"
rm -rf ~/Pictures/iPhoto\ Library/iPod\ Photo\ Cache/*
echo "done cleaning from ~/Pictures/iPhoto Library/iPod Photo Cache"
#application caches
echo "cleaning application caches"
for x in $(ls ~/Library/Containers/)
do
    echo "cleaning ~/Library/Containers/$x/Data/Library/Caches/"
    rm -rf ~/Library/Containers/$x/Data/Library/Caches/*
    echo "done cleaning ~/Library/Containers/$x/Data/Library/Caches"
done
echo "done cleaning for application caches"

echo 'Cleanup Homebrew Cache...'
brew cleanup --force -s &>/dev/null
brew cask cleanup &>/dev/null
rm -rfv /Library/Caches/Homebrew/* &>/dev/null
brew tap --repair &>/dev/null

echo 'Cleanup any old versions of gems'
gem cleanup &>/dev/null

#echo 'Clean up rvm'
#rvm cleanup all

echo 'Purge inactive memory...'
sudo purge

echo 'Delete all desktop Screenshot'
rm ~/Desktop/Screen\ Shot*

removedFmt=(torrent dmg zip rar html gif jpg jpeg png srt gzip docx tar xlsx txt pages md rb pdf log exe)

declare -a deletedPath=(
"Desktop" "Downloads"
)

for i in "${removedFmt[@]}"
do
  for j in "${deletedPath[@]}"
  do
    rm ~/$j/*.$i
  done
done

clear && echo ''
