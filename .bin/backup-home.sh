#!/bin/sh
#
# What to backup. 
backup_files="/home" #/var/spool/mail /etc /root /boot /opt"

# Where to backup to.
dest="/mnt/backup/Home-backup"

# Create archive filename.
day=$(date +%d-%m-%y)
archive_file="$day.tgz"

# Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"
date
echo

# Backup the files using tar.
tar czf $dest/$archive_file $backup_files

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $dest to check file sizes.
ls -lh $dest
