#!/bin/bash
#A script that configures password policies

addpasspolicy() {
	cp /etc/login.defs /etc/login.defs~
	cat >/etc/login.defs <<- EOF
	MAIL_DIR /var/spool/mail
	PASS_MAX_DAYS 30
	PASS_MIN_DAYS 7
	PASS_MIN_LEN 8
	PASS_WARN_AGE 14
	EOF

	cp /etc/pam.d/system-auth /etc/pam.d/systemd-auth~
	cat >/etc/pam.d/system-auth <<- EOF
	auth required pam_env.so
	auth required pam_unix.so try_first_pass likeauth nullokf
	auth required /lib/security/\$ISA/pam_tally.so onerr=fail no_magic_root

	account required pam_unix.so
	account required /lib/security/\$ISA/pam_tally.so per_user_deny=5 no_magic_root reset

	password required pam_cracklib.so retry=3 minlength=8 difok=3
	password required pam_unix.so try_first_pass use_authtok sha512 shadow

	session required pam_limits.so
	session required pam_env.so
	session required pam_unix.so
	EOF
}

addpasspolicy

