#!/bin/bash
#A script that configures sudoers

addsudoers() {
	cp -Ra /etc/sudoers.d /etc/sudoers.d~
	groupdel wheel && groupadd wheel
	cp -a /etc/sudoers /etc/sudoers~
	cat >/etc/sudoers <<- EOF
	root ALL=(ALL) ALL
	%wheel ALL=(ALL) ALL
	EOF

	chown root:root /etc/sudoers
	chmod 600 /etc/sudoers
	echo "Don't forget to manually merge stuff from /etc/sudoers~ and /etc/sudoers.d~/"
}

addsudoers

