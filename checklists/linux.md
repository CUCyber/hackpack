## Linux Checklist

This checklist is designed for the first 30 minutes of competition.

For each system:

* Check for users
	- `cat /etc/passwd`
* Change the password for the root account
	- `type passwd`
	- `cat <path to passwd>`
	- `passwd <user>`
* Check for improper ssh config
	- `ls ~/.ssh`
* Check for improper sshd config
	- `/etc/ssh/sshd_config`
* Check the crontab(s) for running tasks
	- `crontab -l`
	- `crontab -e`
	- not much should be there
* Check for files with wide permissions and setuid
	- setuid bit: `find <dir> -perm -u=s`
	- world writable: `find <dir> -perm -o=w`
* Create a report of running processes
	- `ps aux`
* Create a report of running services
	- `ss -tlnp`
	- `ss -ulnp`
* Audit users and groups for invalid entries
	- `cat /etc/passwd`
	- `cat /etc/shadow`
	- `cat /etc/group`
* Check mounted filesystems
	- `lsblk`
* Install important system and security updates
	- OpenSSL
	- OpenSSH
	- web server
	- file server
	- mail server
	- DNS server
	- Linux kernel (not necessarily to latest major version but to latest security update) - requires reboot
* Run a full system backup
	- See 'Backups and Restoration' -> 'Simple Backups'
* Check and configure '/etc/sudoers' and '/etc/sudoers.d/\*'
* Harden the service(s) for your machine
	- Check for misconfigured files
* Install and configure a firewall
* Check filesystem for proper layout and for any odd files
	- See 'Filesystem Layout and Locations' -> 'Linux Filesystem Hierarchy'
* Write an audit report containing changes made

For all systems:

* Scan the subnet for running servers


### In-Depth Hardening

* Ensure '/tmp' is a seperate partition with nodev,nosuid
* Ensure '/var' is a seperate partition
* Ensure '/var/log' is a separate partition
* Ensure '/var/log/audit' is a separate partition
* Ensure '/home' is a seperate partition with nodev
* Ensure '/run/shm' is `nodev,nosuid,noexec`
* Bind mount '/var/tmp' to '/tmp'
* Require a password for root
* Set hard core limit to `0` in '/etc/security/limits.conf'
* Disable rarely used filesystems and protocols


#### Modprobe


##### /etc/modprobe.d/secure.conf

```conf
install cramfs /bin/true
install freevxfs /bin/true
install jffs2 /bin/true
install hfs /bin/true
install hfsplus /bin/true
install squashfs /bin/true
install udf /bin/true

install dccp /bin/true
install sctp /bin/true
install tipc /bin/true
```


#### Sysctl

* Enable ASLR `/sbin/sysctl kernel.randomize_va_space = 2`
* Disable network forwarding `/sbin/sysctl -w net.ipv4.ip_forward 0`
* Disable packet redirects `/sbin/sysctl -w net.conf.default.send_redirects 0`
* Flush packet redirects `/sbin/sysctl -w net.ipv4.conf.all.send_redirects 0`
* Flush packet redirects `/sbin/sysctl -w net.ipv4.conf.all.send_redirects 0`
* Disable source routed packets `/sbin/sysctl -w net.ipv4.conf.all.accept_source_route 0`
* Disable source routed packets `/sbin/sysctl -w net.ipv4.conf.default.accept_source_route 0`
* Disable ICMP redirect acceptance `/sbin/sysctl -w net.ipv4.conf.all.accept_redirects 0`
* Disable ICMP redirect acceptance `/sbin/sysctl -w net.ipv4.conf.default.accept_redirects 0`
* Disable secure ICMP redirect acceptance `/sbin/sysctl -w net.ipv4.conf.default.secure_redirects 0`
* Disable secure ICMP redirect acceptance `/sbin/sysctl -w net.ipv4.conf.default.secure_redirects 0`
* Disable ICMP broadcast requests `/sbin/sysctl -w net.ipv4.icmp_echo_ignore_broadcasts 1`
* Disable ICMP bad error message protection `/sbin/sysctl -w net.ipv4.icmp_ignore_bogus_error_responces 1`
* Force source route validation `/sbin/sysctl -w net.ipv4.conf.all.rp_filter 1`
* Force source route validation `/sbin/sysctl -w net.ipv4.conf.default.rp_filter 1`
* Use tcp syncookies `/sbin/sysctl -w net.ipv4.tcp_syncookies 1`
* Log suspicious packets `/sbin/sysctl -w net.ipv4.conf.all.log_martians 1`
* Log suspicious packets `/sbin/sysctl -w net.ipv4.conf.default.log_martians 1`
* Flush routing tables `/sbin/sysctl -w net.ipv4.route.flush 1`
* Disable IPv6 router advertisements `/sbin/sysctl -w net.ipv6.conf.all.accept_ra 0`
* Disable IPv6 router advertisements `/sbin/sysctl -w net.ipv6.conf.default.accept_ra 0`
* Disable IPv6 redirect acceptance `/sbin/sysctl -w net.ipv5.confi.all.accept_redirects 0`
* Disable IPv6 redirect acceptance `/sbin/sysctl -w net.ipv5.confi.default.accept_redirects 0`


#### Authentication

* Do not allow '.' to be in root's `PATH` environment variable (check in '/etc/login.defs', '/etc/profile', and '/etc/profile.d')
* Set the shell on unused users to '/bin/nologin'
* Ensure '/etc/passwd' is `root:root` `0600` and contains no lines of +
* Ensure '/etc/group' is `root:root` `0600` and contains no lines of +
* Ensure '/etc/shadow' is `root:root` `0600` and contains no lines of +
* Ensure users own thier home directories with sane permissions
* Use PAM
	- Configure `pam_cracklib retry=3 minlen=14 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1`
	- Configure `pam_unix obscure sha512 remember=5`
	- No empty passwords
* Restrict access to su
	- `echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su`
* Use '/etc/login.defs'
	- Set `PASS_MAX_DAYS`, `PASS_MIN_DAYS`, `PASS_WARN_DAYS`
* Verify root is the only uid `0` account
* Verify root, sync, shutdown, halt, and operator are the only gid `0` accounts
* Verify no duplicate gid
* Verify no duplicate usernames or group names
* Delete all '.forward' files
* Ensure 'shadow' group is empty
* Check for '.rhosts' and '.netrc'


#### Permissions

* No world writable files
	- `find / -perm -o=w`
* Find un-owned files
	- `find / -nouser -o -nogroup`
* Find suid binaries
	- `find / -perm -u=s`
* Find sgid binaries
	- `find / -perm -g=s`
* Use a umask of 077 to prohibit users from reading files that are not theirs (see '/etc/profile')
* Ensure bootloader config, '/boot/grub/grub.cfg', is owned by `root:root` and has permissions `0600`


#### Programs

* If `prelink` is installed, run `/usr/sbin/prelink -ua` and uninstall it
* Where possible, uninstall Xorg
* Ensure rshd, rlogind, rexecd, talk, telnet, tftp, xinetd, chargen, daytime, echo, discard, avahi, cupsd, isc-dhcp-server, ldap, nfs, rpc, bind, vsftpd, apache, dovecot, smbd, squid3, snmp, rsyncd are disabled, and preferably uninstalled, where possible
* Configure ntp
* Create '/etc/hosts.{allow,deny}' files with permissions 0644
* Disable wireless on wired devices
* Ensure a firewall is running
* Use install and use auditd
	- Set `max_log_file = <megabytes>`
	- Use audit to detect time changes, user and group changes, network changes, AppArmor/SELinux, login/logout, sessions, changes to file permissions, unautorized access attempts, priviliged commands, successful mounts, file deletion events, sudoers, kernel module changes
* Use and install rsyslog and configure it to save logs to '/var/log' with appropriate permissions, usually `root:root` `0600`
	- Consolidate logs if possible with remote logging
* Use AIDE/Tripwire
* Use cron where necessary with `root:root` `0600` permissions
* Setup SSH
	- Set enviroment options No
	- Prohibit inactive sessions
		+ ClientAliveInterval 300
		+ ClientAliveCountMax 0


##### /etc/ntp.conf

```conf
restrict -4 default kod nomodify notrap nopeer noquery
restrict -6 default kod nomodify notrap nopeer noquery
```
