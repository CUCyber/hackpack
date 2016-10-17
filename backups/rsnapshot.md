## rsnapshot


### Summary

rnapshot is a utility to create incremental snapshot backups using rsync. It has minimal dependencies and should work even on very old Linux distributions.


### Dependencies

* perl
* rsync
* openssh


### Configuration


#### /etc/rsnapshot.d/system

```rsnapshot
config_version	1.2

no_create_root	1
lockfile	/var/run/rsnapshot.pid

cmd_cp		/bin/cp
cmd_rm		/bin/rm
cmd_rsync	/usr/bin/rsync
cmd_ssh		/usr/bin/ssh
link_dest	1

one_fs		1

snapshot_root	/mnt/backup/

retain		system	8

exclude		/dev/**
exclude		/proc/**
exclude		/sys/**

exclude		/tmp/**

exclude		/var/cache/**
exclude		/var/lock/**
exclude		/var/run/**
exclude		/var/tmp/**

exclude		/usr/portage/distfiles/**

backup		root@example.local:/	example.local/
```


#### /etc/rsnapshot.d/application

```rsnapshot
config_version	1.2

no_create_root	1
lockfile	/var/run/rsnapshot.pid

cmd_cp		/bin/cp
cmd_rm		/bin/rm
cmd_rsync	/usr/bin/rsync
cmd_ssh		/usr/bin/ssh
link_dest	1

one_fs		1

snapshot_root	/mnt/backup/

retain		application	8

exclude		/dev/**
exclude		/proc/**
exclude		/sys/**

exclude		/tmp/**

exclude		/var/cache/**
exclude		/var/lock/**
exclude		/var/run/**
exclude		/var/tmp/**

exclude		/usr/portage/distfiles/**

backup		root@example.local:/etc/	example.local/
backup		root@example.local:/opt/	example.local/
backup		root@example.local:/var/	example.local/
```


#### /etc/cron.d/rsnapshot

```crontab
0,15,30,45 * * * * root rsnapshot -c /etc/rsnapshot.d/application application
8 * * * * root rsnapshot -c /etc/rsnapshot.d/system system
```
