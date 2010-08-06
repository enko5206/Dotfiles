#!/bin/bash
#
# Date
#
DAY=`date +%e/%m/%y`
TIME=`date +%R`
#
# Home Folder
#
HOME=/home/`whoami`
#
# Backup What?
#
BKP_FILES=(
.bashrc
.conkyrc
.dzenconkyrc
.dzenmpdrc
.vimrc
.Xdefaults
.xinitrc
.Xresources
.zshrc
)

BKP_DIR=(
.bin
.colorscheme
.vim
)
#
# Backup Where?
#
BKP_WHERE=/mnt/data/Git/Dotfiles
#
# Colors
#
blue="\033[1;34m"
green="\033[1;32m"
red="\033[1;31m"
bold="\033[1;37m"
reset="\033[0m"
#
# The Script
#
echo -e  "$blue:: Starting Backup $reset"
echo -e  "$blue:: Backing Up Miscellaneous Files $reset"
	for FILE in ${BKP_FILES[@]}; do
		echo -e  "$green Backing Up $blue $FILE $reset"
		cp -r $HOME/$FILE $BKP_WHERE
	done
echo -e  "$blue:: Backing Up Directories $reset"
	for DIR in ${BKP_DIR[@]}; do
		echo -e  "$green Backing Up $blue $DIR $reset"
		cp -ur $HOME/$DIR $BKP_WHERE
	done
echo -e  "$blue:: Doing Other Backups $reset"
echo -e  "$green mc $reset"
    if [ -d $BKP_WHERE/.mc ]; then 
		cp -r $HOME/.mc/ini $BKP_WHERE/.mc/
	else	
		mkdir $BKP_WHERE/.mc
		cp -r $HOME/.mc/ini $BKP_WHERE/.mc/
	fi
echo -e  "$green moc $reset"
    if [ -d $BKP_WHERE/.moc ]; then 
		cp -r $HOME/.moc/config $BKP_WHERE/.moc/
	else	
		mkdir $BKP_WHERE/.moc
		cp -r $HOME/.moc/config $BKP_WHERE/.moc/
	fi
echo -e  "$green mpd $reset"
    if [ -d $BKP_WHERE/.mpd ]; then 
		cp -r $HOME/.mpd/config $BKP_WHERE/.mpd/
	else	
		mkdir $BKP_WHERE/.mpd
		cp -r $HOME/.mpd/config $BKP_WHERE/.mpd/
	fi
echo -e  "$green ncmpcpp $reset"
	if [ -d $BKP_WHERE/.ncmpcpp ]; then 
		cp -r $HOME/.ncmpcpp/config $BKP_WHERE/.ncmpcpp/
	else	
		mkdir $BKP_WHERE/.ncmpcpp
		cp -r $HOME/.ncmpcpp/config $BKP_WHERE/.ncmpcpp/
	fi
echo -e  "$green Xmonad $reset"
	if [ -d $BKP_WHERE/.xmonad ]; then 
		cp -r $HOME/.xmonad/xmonad.hs $BKP_WHERE/.xmonad/
	else	
		mkdir $BKP_WHERE/.xmonad
		cp -r $HOME/.xmonad/xmonad.hs $BKP_WHERE/.xmonad/
	fi
echo -e  "$blue:: $blue Backup completed $blue:: $green$DAY $TIME"
echo "$DAY :: $TIME - Backup Completed" >> $BKP_WHERE/backup.log
echo "cd /mnt/data/Git/Dotfiles && git commit -a && git push origin master"
exit 0
