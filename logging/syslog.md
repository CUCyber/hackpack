## Rsyslog

Rsyslog is a client and server that conforms to the syslog protocol. On systems with systemd (i.e. RedHat and newer Debian distributions), journald is typically used instead, but both programs can be used to compliment each other.


### Config Files

Rsyslog is generally configured by /etc/syslog.conf and /etc/syslog.conf.d/ most other syslog daemons.

```sh
#!/bin/bash
# a script that installs a sane syslog configuration

addsyslog() {
	cp -Ra /etc/syslog.conf.d /etc/syslog.conf.d~
	cp -a /etc/syslog.conf /etc/syslog.conf~
	cat >/etc/syslog.conf <<- EOF
	*.err;kern.debug						/dev/console
	auth.notice;authpriv.none				/dev/console
	*.err;*.crit;*.emerg					/var/log/critical.log
	*.notice								/var/log/messages
	auth,authpriv.none						/var/log/messages
	auth,authpriv.debug						/var/log/auth.log
	cron.info								/var/log/cron.log
	news,kern,lpr,daemon,ftp,mail.info		/var/log/daemon.log
	*.err;user.none							root
	*.emerg;user.none						*
EOF
}
```
