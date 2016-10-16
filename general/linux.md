## Linux Checklist

This checklist is designed for the first 30 minutes of competition.

For each system:

* Change the password for the root account
* Check for improper ssh config
* Check for improper sshd config
* Check the crontab (s) for running tasks
* Check with files with wider permissions and setuid
* Create a report of running services and processes and disable unnecessary processes
* Create a report of open ports
* Audit user, groups for invalid entries
* Check mount/nfs if it is running
* Install updates
* Run a full system backup
* Check/Configure '/etc/sudoers' and '/etc/sudoers.d/\*'
* Harden the service for your machine
* Install/Configure a firewall
* Write an audit report containing changes made

For all systems:

* Scan the subnet for running servers
* Configure a provisioner such as Salt/Ansible


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
* Find sgid binaries
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
