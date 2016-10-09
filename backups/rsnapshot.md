## rsnapshot


### Summary

rnapshot is a utility to create incremental snapshot backups using rsync. It has minimal dependencies and should work even on very old Linux distributions.


### Dependencies

* perl
* rsync
* openssh


### Commands

```sh
#!/bin/bash
#A script that sets up backups

install_backup() {
	if [ -f /etc/debian_version ]; then
		apt-get install rsnapshot
	elif [ -f /etc/redhat-release ]; then
		if [ -f /usr/bin/dnf ]; then
			dnf install rsnapshot
		else
			yum install rsnapshot
		fi
	elif [ -f /etc/arch-release ]; then
		pacman -S rsnapshot
	elif [ -f /etc/gentoo-release ]; then
		emerge rsnapshot
	else
		wget http://rsnapshot.org/downloads/rsnapshot-1.4.2.tar.gz
		tar xzf rsnapshot-1.4.2.tar.gz

		cd rsnapshot-1.4.2

		./configure && make && make install

		cd ..

		rm -rf rsnapshot-1.4.2
		rm rsnapshot-1.4.2.tar.gz
	fi
}

configure_backup() {
	mkdir /mnt/backup

	mkdir /etc/rsnapshot.d

	cat >/etc/rsnapshot.d/system <<- EOF
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
	EOF

	cat >/etc/rsnapshot.d/application <<- EOF
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
	EOF

	cat >>/etc/crontab <<- EOF
	0,15,30,45 * * * * root rsnapshot -c /etc/rsnapshot.d/application application
	8 * * * * root rsnapshot -c /etc/rsnapshot.d/system system
	EOF
}

add_backup_host() {
	cat >>/etc/rsnapshot.d/system <<- EOF

	backup		root@$1:/	$1/
	EOF

	cat >>/etc/rsnapshot.d/application <<- EOF

	backup		root@$1:/etc/	$1/
	backup		root@$1:/opt/	$1/
	backup		root@$1:/var/	$1/
	EOF
}

install_backup
configure_backup
```
