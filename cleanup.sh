#!/usr/bin/env bash

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

echo 'Cleanup Homebrew Cache...'
brew cleanup --force -s &>/dev/null
brew cask cleanup &>/dev/null
rm -rfv /Library/Caches/Homebrew/* &>/dev/null
brew tap --repair &>/dev/null

echo 'Cleanup any old versions of gems'
gem cleanup &>/dev/null

echo 'Clean up rvm'
rvm cleanup all

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

clear && echo 'Everything is cleaned up :3'
