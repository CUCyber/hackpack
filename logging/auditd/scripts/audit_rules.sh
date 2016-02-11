#Remove all rules
auditctl -D

#See a list of rules
auditctl -l

#Watch a file for writes
auditctl -w /etc/passwd -p wa -k passwd_access

#Watch a directory and all its children for writes
auditctl -w /etc/ -p wa -k etc_writes

#Watch for use of a specific syscalls
auditctl -a always,exit -S stime.* -k time_changes
auditctl -a always,exit -S setrlimit.* -k setrlimits
auditctl -a always,exit -S unlink -S rmdir -k deleting_files

#Watch for unsucessful calls
#The -F flag filters out based on various options see man auditctl for more details
auditctl -a always,exit -S all -F sucess=0

#Make the default audit log buffer larger
auditctl -b 1024

#Lock audit rules so that they cannot be edited until reboot
auditctl -e 2
