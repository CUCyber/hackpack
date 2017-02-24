## SECCDC Competition Starting Checklist

Below are competition specific go plans for various hosts in the SECCDC Pre-Qualifier.


### DNS

The DNS box is running Ubuntu 8.04. There is no hope for patching this box up to the latest security patches, but it can be locked down to (for the most part) only allow the required service configured in such a way to minimize attack surface area.


#### Unnecessary Services

```sh
/etc/init.d/mysql stop # MySQL
/etc/init.d/ssh stop # SSH
/etc/init.d/apache2 stop # Apache
/etc/init.d/nfs-kernel-server stop # NFS
/etc/init.d/nfs-common stop # NFS
/etc/init.d/portmap stop # NFS
```


#### BIND


##### /etc/init.d/named.conf.options

Apply the following configuration to the existing `options` section and remove conflicting directives from the old configuration.

```bind
options {
	allow-transfer { "none"; };
	version "none";
	fetch-glue no;
	recursion no;
}
```


#### Firewall

The Ubuntu box has UFW installed by default. Use the following commands to enable it and configure it for only allowing BIND queries.

```sh
ufw default deny
ufw allow 53/UDP
ufw logging on
```


#### Apply Configuration

Do not forget to go through the standard Linux checklist!

```sh
/etc/init.d/bind9 restart
ufw enable
```


### eCommerce

The eCommerce box runs CentOS 5.9 which although old, is relatively secure by default. Unfortunately, it has a ton of surface area between the graphical user interface and wide open Apache rules.


#### Unnecessary Services

```sh
yum remove libX11 xserver-xorg
/etc/init.d/sshd stop
/etc/init.d/proftp stop
/etc/init.d/portmap stop
/etc/init.d/nfs stop
/etc/init.d/sendmail stop
/etc/init.d/mysql stop
```


#### Postfix

Postfix should be used in place of Sendmail for the case of sending emails. It is easy to install and for send-only has minimal required configuration.


##### /etc/postfix/main.cf

Apply the below configuration where the original options are in the main configuration file. These will only allow connections from localhost and disable local delivery.

```postfix
inet_interfaces = loopback-only
local_transport = error:local delivery is disabled
```


#### Apache

The following configuration options should be disabled on Apahce to reduce features to little more than static file hosting and PHP execution.

```apache
#LoadModule mod_status "modules/mod_status.so"
#LoadModule mod_info "modules/mod_info.so"
#LoadModule mod_autoindex "modules/mod_autoindex.so"
#LoadModule mod_cgi "modules/mod_cgi.so"
#Options [anything] # there will be multiple of these
```

The '.htaccess' files should also be merged into the system configuration in '/etc/httpd/conf.d/ecomm.conf'.

```apache
<Location "[directory of htaccess file]">
	[contents of htaccess file]
</Location>
```

The overrides ('.htaccess' files) should now be disabled.

```apache
AllowOverride None # there will be multiple of these
```


#### Webapp

The 'robots.txt' file and file permissions need to be fixed for security.

```sh
find /var/www -type d -exec chmod 750 {} \;
find /var/www -type f -exec chmod 640 {} \;
chown -R root:apache /var/www
chmod 660 /var/www/{cache,logs,tmp}
```


##### robots.txt

```txt
User-agent: *
Disallow: /
```


#### Apply Configuration

Do not forget to go through the standard Linux checklist!

```sh
/etc/init.d/postfix restart
/etc/init.d/httpd restart
```


### Email

The email box has preinstalled malware in addition to a graphical user interface.


#### Malware

Use the following commands to find the obvious malware and then monitor processes after restarting to find further malware.

```sh
mv /boot/initrd.img-2.6.26-2-268.bak /boot/initrd.img-2.6.26-2-268
crontab -e # remove line in this file
```


#### GUI

Remove the GUI since it is large surface area with the potential for keyloggers and things.

```sh
apt-get purge libx11-6 xserver-xorg libpango1.0-common
```


#### APT

The APT sources need to be adjusted to the archives to get a working package manager.


##### /etc/apt/sources.list

```apt
deb http://archive.debian.org/debian/ lenny/main
deb http://archive.debian.org/debian-security/ lenny/updates
deb http://archive.debian.org/debian-volatile/ lenny/volatile
```


#### Reboot

After the malware and GUI have been purged and APT fixed, you need to reboot the machine.

```sh
reboot
```


#### Unnecessary Services

Run the `ss -tlp` command to get all running services and stop all of them by their init script '/etc/init.d/[service] stop'.


#### FTP

This box will also host the FTP server as the Windows box dedicated to the task is irreparably vulnerable. The FTP server of choice is `vsftpd`. Apply the changes to the following configuration file to reduce privileges and spoof the banner as the Windows FTP server. Before turning the Windows box off, copy all of the FTP files to '/home/ftp' using the `ftp` command.


##### /etc/vsftpd.conf

```conf
nopriv_user=ftp
ftpd-banner=Windows FTP Server
```


#### Postfix

Install `postfix` as an alternative to Sendmail that should basically be automatically configured for what Sendmail did. Check over netcat to be sure everything works and gives the right headers.


#### Firewall

This box does not have any simple firewall so iptables will be necessary.

```sh
iptables -F # clear rules
iptables -X # clear chains
iptables -P INPUT DROP # set default drop policy
iptables -A INPUT -i lo -j ACCEPT # allow loopback interface
iptables -A INPUT -p tcp --dport ftp -j ACCEPT # allow ftp
iptables -A INPUT -p tcp --dport smtp -j ACCEPT # allow smtp
iptables -A INPUT -p tcp --dport imap -j ACCEPT # allow imap
iptables -A INPUT -p tcp --dport pop3 -j ACCEPT # allow pop3
```


#### Apply Configuration

Do not forget to go through the standard Linux checklist!

```sh
/etc/init.d/vsftpd restart
/etc/init.d/dovecot restart
/etc/init.d/postfix restart
```
