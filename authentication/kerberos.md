## Kerberos

Kerberos is a remote login service that allows a set of Linux and Windows servers to share users and groups. The current version of the protocol is version 5, and version 4 is deprecated and should not be used due to weak cryptography.


### Installation

Kerberos can be configured to either authenticate against either Linux or a Windows Active Directory server.

Here is how to install and configure Kerberos to run on Linux:

```sh
#!/bin/sh
# if you can, use realmd (newer servers)
realm discover
realm join "realm_name"
realm permit -a

# which roughly does the following on the backend

#####################################################################
##this section is roughly based on the ArchLinux Wiki documentation##
##Which is available under the GNU Free Document License           ##
#####################################################################
# first install and configure NTP and name resolution for the servers
# next, configure the /etc/krb5.conf file as shown below

# verify that you can now login
kinit administrator@EXAMPLE.COM
klist

# if there are errors regarding a missing pam_winbind make a file called
# 'pam_winbind.conf' with the contents of the next section

# configure Samba as specified in the Samba series section

net ads join -U Administartor

# start and enable the required services
systemctl start smbd nmbd winbindd

# configure /etc/nsswitch.conf as shown below

# test winbind and nss(Windows Authentication service)
wbinfo -u
wbinfo -g
getent passwd
getent group
net ads info
net ads lookup
net ads status -U administrator

# configure PAM with the following config.

# modify applications as necessary to use Kerberos; see the specific application for documentation

# finally configure smb shares and keytabs if desired using the following
```

#### /etc/pam\_winbind.conf

```ini
[global]
  debug = no
  debug_state = no
  try_first_pass = yes
  krb5_auth = yes
  krb5_cache_type = FILE
  cached_login = yes
  silent = no
  mkhomedir = yes
```


#### /etc/pam.d/krb5

```pam
#%PAM-1.0

auth [success=1 default=ignore] pam_localuser.so
auth [success=2 default=die] pam_winbind.so
auth [success=1 default=die] pam_unix.so nullok
auth requisite pam_deny.so
auth      optional  pam_permit.so
auth      required  pam_env.so


account   required  pam_unix.so
account [success=1 default=ignore] pam_localuser.so
account required pam_winbind.so
account   optional  pam_permit.so
account   required  pam_time.so

password [success=1 default=ignore] pam_localuser.so
password [success=2 default=die] pam_winbind.so
password [success=1 default=die] pam_unix.so sha512 shadow
password requisite pam_deny.so
password  optional  pam_permit.so

session   required  pam_limits.so
session required pam_mkhomedir.so skel=/etc/skel/ umask=0022
session   required  pam_unix.so
session [success=1 default=ignore] pam_localuser.so
session required pam_winbind.so
session   optional  pam_permit.so
```


#### /etc/krb5.conf

```ini
[libdefaults]
	#Default Realm must be unique on the network, by convention it is all caps
	default_realm = EXAMPLE.COM
	#if Windows Server 2008 and older require weak crypto; Think carefully before using
	allow_weak_crypto = true

[realms]
	EXAMPLE.COM = {
		#host where the auth server is running given as a fqdm:port
		admin_server = kerberos_server.example.com:749
		#Name(s) of a host running a Kerberos Key Distribution Server
		#These are nessisary if realm admins don't have SRV records in DNS
		kdc = kerberos_server.example.com:88
		kdc = kerberos_server2.example.com:88
	}
[domain_realm]
	#maps host names to kerberos realms
	#domains beginning with a . include all subdomains of the specified domain
	.example.com = EXAMPLE.COM
	example.com = EXAMPLE.COM

[logging]
	default = FILE:/var/log/krb5libs.log
```
