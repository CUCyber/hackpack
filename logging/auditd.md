## auditd

Linux has a built-in auditing framework that acts in kernel space. This portion of the kernel communicates with the userspace auditd server. It can be configured to monitor files and syscalls.


### Installation

```sh
#!/bin/sh
dnf install audit
systemctl start auditd
```


### Config Files

The user space auditing commands, can be used to configure logs. Audit can stores its rules in /etc/audit/audit.rules or in files inside /etc/audit/audit.d/. The syntax for these files is the same as the user space commands.


### Commands

Viewing the auditlog can be done in a few ways:

* aureport - query logs for a specific event
* ausearch - view a summary of recent events
* syslog - view logs typically stored in /var/log/audit/audit.log


### Example Configuration

```sh
#!/bin/sh
# remove all rules
auditctl -D

# see a list of rules
auditctl -l

# watch a file for writes
auditctl -w /etc/passwd -p wa -k passwd_access

# watch a directory and all its children for writes
auditctl -w /etc/ -p wa -k etc_writes

# watch for use of a specific syscalls
auditctl -a always,exit -S stime.* -k time_changes
auditctl -a always,exit -S setrlimit.* -k setrlimits
auditctl -a always,exit -S unlink -S rmdir -k deleting_files

# watch for unsucessful calls
# the -F flag filters out based on various options see man auditctl for more details
auditctl -a always,exit -S all -F sucess=0

# make the default audit log buffer larger
auditctl -b 1024

# lock audit rules so that they cannot be edited until reboot
auditctl -e 2
```
