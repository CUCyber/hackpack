#!/bin/bash
#A script that scans and fixes unusual permissions

#Find devices with execute permissions and remove the execute permissions
fixdev() {
	find /dev \( -type c -or -type b -or -type f \) -perm -+x -exec chmod -x {} \;
}

#Barring unusual circumstances, files in a home directory should be 640
fixhome() {
	sed -i -e "s/^umask [0-9][0-9][0-9]$/umask 027/" /etc/profile
	for file in $(find /home/*); do
		if [ -d "$file" ]; then
			#Directories must have execute permissions
			chmod 750 "$file"
		elif [ -x "$file" ]; then
			#Some users will have scripts in there home directory
			read "Should this file be executable ($file) ?" yes
			if [ $yes -eq "y" ]; then
				chmod 750 "$file"
			else
				chmod 640 "$file"
			fi
		else
			#If it is not a file or directory, mark it 640
			chmod 640 "$file"
		fi
	done
}

fixdev
fixhome

