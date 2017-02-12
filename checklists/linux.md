## Linux Checklist

This checklist is designed for the first 30 minutes of competition.

For each system:

* Check for users
	- `cat /etc/passwd`
* Change the password for the root account
	- `which passwd`
	- `cat [path to passwd]`
	- `passwd [user]`
* Check for improper ssh config
	- `ls ~/.ssh`
* Check for improper sshd config
	- `/etc/ssh/sshd_config`
* Check the crontab (s) for running tasks
	- `crontab -e` or `crontab -l`
	- NOTHING SHOULD BE THERE
* Check with files with wider permissions and setuid
	- sticky bit: `find [dir] -perm -u=s`
	- `find [dir] -perm -o=w`
* Create a report of running services and processes and disable unnecessary processes
	- `ps aux`
* Create a report of open ports
	- `ss -tlnp`
	- `ss -ulnp`
* Audit user, groups for invalid entries
	- `cat /etc/group`
* Check mount/nfs if it is running
	- `lsblk`
* Install updates
	- update important things, not the whole system
		+ openssl
		+ openssh
		+ * server
		+ kernel (maybe)
* Run a full system backup
	- run script from hackpack
* Check/Configure '/etc/sudoers' and '/etc/sudoers.d/\*'
* Harden the service for your machine
	- check for misconfigured files
* Install/Configure a firewall
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
* Disable Rarely Used Filesystems and Protocols

## Directory Hierarchy

* `/etc
	- Back me up
	- configuration files
	- notable files
		+ passwd
		+ shadow
		+ group
		+ pam.d
		+ sudoers
		+ crontab
		+ cron.d
	- service configurations
		+ sshd
		+ httpd
		+ apache2
		+ nginx
* `/var`
	- Back me up
	- databases
	- logs
	- webpage files `/var/www`
* `/tmp`
	- Temporary files will be here typically gone by the next reboot
	- Sockets will also be in temp 
		+ If you find .X11-unix close it
		+ ice-unix close it
* `/home`
	- User home dirs
		+ User data files
	- Some user system datafiles will be located in var, these are typcally
	for service users
* `/root`
	- Roots home dir
* `/bin`
	- Core exe's for running the system
	- Coreutils
* `/opt`
	- Special programs, programs that are not system level
* `/usr`
	- Non-critical system programs go
	- Has its own bin, lib, libexec, usr/share
	- /usr/share
		+ Place for files that don't go in /etc or /var
* `/lib`
	- Core library file 
* `/libexec`
	- look here
	- Scripts shouldn't be here
* `/proc`
	- Information on processes
	- Red teams will go here to see if they can manipulate the processes
	- Central to how linux works
* `/dev`
	- Central to how linux works
	- Red teams will go here to see if they can manipulate things
* `/sys`
	- sysctls stuff
	- Typically not much useful information

#### Modprobe


##### /etc/modprobe.d/secure.conf

```conf
install cramfs /bin/true
install freevxfs  /bin/true
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

* Use `sysctl kernel.randomize_va_space = 2`
* Disable network forwarding `/sbin/sysctl -w net.ipv4.ip_forward  0`
* Disable packet redirects `/sbin/sysctl -w net.conf.default.send_redirects  0`
* Flush packet redirects `/sbin/sysctl -w net.ipv4.conf.all.send_redirects  0`
* Flush packet redirects `/sbin/sysctl -w net.ipv4.conf.all.send_redirects  0`
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
* Flush routing tables `/sbin/sysctl -w net.ipv4.route.flush  1`
* Disable ipv6 router advertisements `/sbin/sysctl -w net.ipv6.conf.all.accept_ra 0`
* Disable ipv6 router advertisements `/sbin/sysctl -w net.ipv6.conf.default.accept_ra 0`
* Disable ipv6 redirect acceptance `/sbin/sysctl -w net.ipv5.confi.all.accept_redirects 0`
* Disable ipv6 redirect acceptance `/sbin/sysctl -w net.ipv5.confi.default.accept_redirects 0`


#### Authentication

* Do not allow '.' to be in root's `PATH`
* Disable shell on non-used users
* Ensure '/etc/passwd' is `root:root` `0600` and contains no lines of +
* Ensure '/etc/group' is `root:root` `0600` and contains no lines of +
* Ensure '/etc/shadow' is `root:root` `0600` and contains no lines of +
* Check that all groups in '/etc/passwd' are in '/etc/groups' and visa-versa
* Ensure users own thier home directories with sane permissions
* Use PAM
	- Configure `pam_cracklib retry=3 minlen=14 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1`
	- Configure `pam_unix obscure sha512 remember=5`
	- No empty passwords
* Restrict access to su
    `echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su`
* Use '/etc/login.defs'
	- Set `PASS_MAX_DAYS`, `PASS_MIN_DAYS`, `PASS_WARN_DAYS`
* Verify root is the only uid `0` account - also check other accounts
* Verify no duplicate gid
* Verify no duplicate usernames or group names
* Delete all '.forward' files
* Ensure shadow group is empty
* Check for '.rhosts', '.netrc'


#### Permissions

* No world writable files
* Find un-owned files
* Find suid binaries
	- find -r / -perm -u=s
* Find sgid binaries
	- find -r / -perm -g=s
* Use a umask of 077 to prohibit users from reading files that are not theirs
* Ensure bootloader config, '/boot/grub/grub.cfg', is `root:root` `0600`


#### Programs

* If `prelink` is installed, run `/usr/sbin/prelink -ua` and uninstall it
* Where possible, uninstall Xorg
* Ensure rshd,rlogind,rexecd,talk,telnet,tftp,xinetd,chargen,daytime,echo,discard,avahi,cupsd,isc-dhcp-server,ldap,nfs,rpc,bind,vsftpd,apache,dovecot,smbd,squid3,snmp,rsyncd are disabled, preferably uninstalled where possible
* Configure ntp
* Create '/etc/hosts.{allow,deny}' files with permissions 0644
* Disable wireless on wired devices
* Ensure a firewall is running
* Use install and use auditd
	- Set `max_log_file = <SOME_NUMBER_OF_MB>`
	- Use audit to detect time changes, user and group changes, network changes, AppArmor/SELinux, login/logout, sessions, changes to file permissions, unautorized access attempts, priviliged commands, successful mounts, file deletion events, sudoers, kernel module changes
* Use and install rsyslog and configure it to save logs to '/var/log' with appropriate permissions `root:root` `0600`
	- Consolidate logs if possible with remote logging
* Use AIDE/Tripwire
* Use Cron to where necessary with `root:root` `0600` permissions
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
