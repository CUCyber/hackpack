## Samba

Samba is reimplementation of the Serial Message Block Protocol from Windows.


### Example Configuration

The following configuration allows the machine to authneticate to a Windows AD via Kerberos.


#### samba.conf

```ini
# this config file based on the Archlinux Wiki which is published under the GFDL

[Global]
	#Server information
	netbios name = EXAMPLEHOST
	workgroup = EXAMPLE
	realm = EXAMPLE.COM
	server string = %h  Host

	#Authentication
	security = ads
	encrypt passwords = yes
	password server = ad_server.example.com
	idmap config * : backend = rid
	idmap config * : range = 10000-20000

	#Windows domain authentication
	winbind use default domain = Yes
	winbind enum users = Yes
	winbind enum groups = Yes
	winbind nested groups = Yes
	winbind separator = +
	winbind refresh tickets = yes
	winbind offline logon = yes
	winbind cache time = 300

	#New User Template
	template shell = /bin/bash
	template homedir = /home/%D/%U

	preferred master = no
	dns proxy = no
	wins server = ad_server.example.com
	wins proxy = no

	inherit acls = Yes
	map acl inherit = Yes
	acl group control = yes

	load printers = no
	debug level = 3
	use sendfile = no
```


#### smb.conf

```ini
[ExampleShare]
  comment = Example Share
  path = /srv/exports/example
  read only = no
  browseable = yes
  valid users = @NETWORK+"Domain Admins" NETWORK+test.user
```
