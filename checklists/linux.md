## Linux Checklist

This checklist is designed for the first 30 minutes of competition.

For each system:

* Download toolset:
	- `wget -qO- http://bit.ly/2GqAfTb | tar -xzv`
* Change the password for the root account
	- find path to 'passwd': `type passwd`
	- ensure passwd is not a script: `cat <path to passwd>`
	- `passwd <user>`
* Audit users and groups for invalid entries
	- `cat /etc/passwd`
	- `cat /etc/shadow`
	- `cat /etc/group`
	- '/etc/fstab' - owned by 'root:root' - has permission '0644'
	- '/etc/passwd', '/etc/shadow', & '/etc/group' are all owned by 'root:root'
	- '/etc/passwd' & '/etc/group' - has permission 644
	- '/etc/shadow' - has permission 400
* Check the crontab(s) for running tasks
	- `crontab -l`
	- `crontab -e`
	- Limit cron to root
		+ `cd /etc/`
		+ `/bin/rm -f cron.deny at.deny`
		+ `echo root >cron.allow`
		+ `echo root >at.allow`
		+ `/bin/chown root:root cron.allow at.allow`
		+ `/bin/chmod 400 cron.allow at.allow`
* Create a report of running processes
	- `ps aux`
* Create a report of running services
	- `ss -tulpn`
* Check for files with wide permissions and setuid
	- setuid bit: `find <dir> -perm -u=s`
	- world writable: `find <dir> -perm -o=w`
	- See 'Filesystem and Access Control Permissions' -> '/home' and '/var/www'
* Check mounted filesystems
	- `lsblk`
* Install important system and security updates
	- OpenSSL, OpenSSH, Apache, FTP, SMTP, DNS
	- Linux kernel (not necessarily to latest major version but to latest security update) - requires reboot
* Run a full system backup
	- See 'Backups and Restoration' -> 'Simple Backups'
* Check and configure '/etc/sudoers' and '/etc/sudoers.d/*'
* Harden the service(s) for your machine
	- Check for misconfigured files
	- Install and configure a firewall
		- 'ufw' or 'firewalld'
* Write an audit report containing changes made
