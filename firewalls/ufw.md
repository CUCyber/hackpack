## Uncomplicated Firewall


### Config Files

Uncomplicated Firewall references mainly the following files:

* '/etc/default/ufw' - high level configuration
* '/etc/ufw/sysctl.conf' - kernel tunables


### Commands

* `ufw enable` - enables and reloads the firewall
* `ufw default` - sets default action
* `ufw allow` - allows service or port
* `ufw deny` - blocks a service or port
* `ufw limit` - allows with connection rate limiting
* `ufw status` verbose - display the current firewall rules (if active)


### Sample Usage

* `ufw allow 8080/tcp` - adds a rule that allows incoming traffic on tcp port 22
* `ufw delete allow 8080/tcp` - deletes the previous rule


### Filtering

Uncomplicated Firewall is based on iptables and therefore inherits iptables's first match rule.


### Example Configuration

```sh
#!/bin/sh
ufw default deny
ufw allow ssh/tcp
ufw logging on
ufw enable
```
