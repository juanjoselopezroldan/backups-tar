#!/bin/bash

#Get the day of the week for do backup full the sundays and the rest of days a backup incremental
DAY=$(date '+%u')
DATE=$(date '+%Y%m%d')
DATE-1=$(date '+%Y%m%d' --date='-1 day')

#If is sunday or if is the firts copy, does backups full and if not is sunday does backups incrementals
if [[ $DAY == '7' || ! -d /path/of/backups/files-snar ]]; then
	# Delete file snar for to do backup full
	rm /path/of/backups/*.snar
	# Access to the path and to do the backup also of make of file snar for the backup incremental and so compare the changes that to have the files
	cd /path/of/backups/ \
	&& tar --listed-incremental /path/of/backups/file.snar -czpf /path/of/backups/backup-full-$DATE.tar.gz "/PATH/DIRECTORY"
	# Backup of file snar for to have a backrest in case of to accidental delete
	if [[ ! -d /path/of/backups/files-snar ]]; then
		# If the directory is not exist, this directory is created
		mkdir -p /path/of/backups/files-snar
	else
		# If the directory exist, a backup copy of the file that has the information is made of the copy and is deleted the original file
		cp /path/of/backups/file.snar /path/of/backups/files-snar/file-$DATE.snar
		rm /path/of/backups/file.snar
	fi
else
	# If the file snar is not exist, copy the backrest of this file
	if [[ ! -f /path/of/backups/file.snar ]]; then
		cp /path/of/backups/files-snar/file-$DATE-1.snar /path/of/backups/file.snar
	fi
	cd /path/of/backups/ \
	&& tar --listed-incremental /path/of/backups/file.snar -czpf /path/of/backups/backup-incremental-$DATE.tar.gz "/PATH/DIRECTORY"

	# When to finished the copy incremental, copy the file snar and to delete the orginal file
	cp /path/of/backups/file.snar /path/of/backups/files-snar/file-$DATE.snar
	rm /path/of/backups/file.snar
fi
