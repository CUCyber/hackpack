#!/bin/bash
#A script that sets up sshd

addsshd() {
	cp -a /etc/ssh/sshd_config /etc/ssh/sshd_config~
	cat >/etc/ssh/sshd_config <<EOF
PermitRootLogin no
UsePAM yes
UsePrivilegeSeparation sandbox
AcceptEnv LANG LC_*
EOF
}

addsshd

