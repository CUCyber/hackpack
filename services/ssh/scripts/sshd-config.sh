#!/bin/bash
#A script that sets up sshd

configure_sshd() {
	#Make a backup before changing anything
	cp -a /etc/ssh/sshd_config /etc/ssh/sshd_config~

	#Apply a sane configuration
	cat >/etc/ssh/sshd_config <<- EOF
	PermitRootLogin no
	UsePAM yes
	UsePrivilegeSeparation sandbox
	AcceptEnv LANG LC_*
	EOF

	#After the config file is modified restart the service
}

user_purge_keys() {
	for key_dir in $(awk 'BEGIN { FS=":"} {print $6}' /etc/passwd)
	do
		if [ -d "$key_dir/.ssh" ];then
			test -f "$key_dir/.ssh/authorized_keys" && \
				mv  "$key_dir/.ssh/authorized_keys" "$key_dir/.ssh/authorized_keys~" &>/dev/null
			test -f  "$key_dir/.ssh/rhosts" && \
				mv  "$key_dir/.ssh/rhosts" "$key_dir/.ssh/rhosts~" &>/dev/null
			test -f "$key_dir/.ssh/shosts" && \
				mv  "$key_dir/.ssh/shosts" "$key_dir/.ssh/shosts~" &>/dev/null
			ls "$key_dir/.ssh/id*" &> /dev/null && echo "found keys at $key_dir/.ssh"
		fi
	done
}

system_purge_keys() {
	test -f /etc/hosts.equiv && mv  /etc/hosts.equiv /etc/hosts.equiv &> /dev/null
	test -f /etc/shosts.equiv && mv  /etc/shosts.equiv /etc/shosts.equiv &> /dev/null
}

restart_sshd() {
	if [ -d /usr/lib/systemd/system ]; then
		systemctl restart sshd
	else
		service sshd restart
	fi
}

configure_sshd
user_purge_keys
system_purge_keys
restart_sshd
