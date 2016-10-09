## UFW


### Config Files

ufw references mainly the following files:

* /etc/default/ufw - high level configuration
* /etc/ufw/sysctl.conf - kernel tunables


### Commands

* ufw enable - enables and reloads the firewall
* ufw default - sets default action
* ufw allow - allows service or port
* ufw deny - blocks a service or port
* ufw limit - allows with connection rate limiting


### Filtering

UFW is based on iptables and therefore inherits iptables's first match rule.


### Example Configuration

```sh
#!/usr/bin/sh
ufw default deny
ufw allow ssh/tcp
ufw logging on
ufw enable
```
