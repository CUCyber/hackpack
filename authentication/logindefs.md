## login.defs

'/etc/login.defs' is a configuration file that controls login functionality on Linux machines using encrypted password files. It is one of 3 tools that can control this process (login.defs, pam, systemd-logind).


### Best Practices


#### /etc/login.defs

* set `CONSOLE` to `/etc/securetty`
* set `PASS_MAX_DAYS` to 30
* set `PASS_MIN_DAYS` to 7
* set `PASS_WARN_DAYS` to 8
* set `PASS_MIN_LEN` to 8
* set `MAIL_DIR` to `/var/spool/mail`
* set `UMASK` to 077


#### /etc/securetty

```conf
console
tty1
tty2
tty3
tty4
tty5
tty6
```
