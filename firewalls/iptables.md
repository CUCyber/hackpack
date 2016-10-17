## iptables


### Config Files

iptables stores the majority of its configuration in a series of files:

* '/etc/sysconfig/iptables' - iptables configuration (RedHat-based distributions)
* '/etc/iptables' - iptables configuration (Debian-based distributions)
* '/etc/services' - an optional file that maps service names to port numbers


### Commands

iptables uses the following binaries:

* `iptables` - view and modify the firewall
* `iptables-save` - prints the running configuration to stdout; used to save the running configuration to a file
* `iptables-restore` - reads a file and sets the firewall configuration

While a save format exists, iptables is normally configured via shell commands to avoid inconsistencies between save file versions.


### Filtering

iptables will stop processing a packet when it matches the first rule. The only exception to this is the LOG target. When the LOG target is matched, matching will continue; but the traffic will be logged in the kernel log.


### Example Configuration

```sh
#!/bin/bash

# clear out the current configuration
iptables -F && iptables -X

# allow traffic on the loopback interface
iptables -A INPUT -i lo -j ACCEPT

# ext_if is the device with the default route
ext_if=$(ip route | head -n 1 | awk '{print $5}')

# broken is a list of address that should be blocked on the external interface
# WARNING! Assumes that there is an internal and an external interface
# note that 192.168.0.0/16 should not be blocked if there is only one interface
broken="224.0.0.22 127.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12, \
		10.0.0.0/8, 169.254.0.0/16, 192.0.2.0/24, \
		192.0.2.0/24, 198.51.100.0/24, 203.0.113.0/24, \
		169.254.0.0/16, 0.0.0.0/8, 240.0.0.0/4, 255.255.255.255/32"


# use a default drop policy
iptables -P INPUT DROP

# disable all ipv6 traffic; Syntax is the same as ipv4 if required
ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP
ip6tables -P FORWARD DROP

# log traffic that is dropped by the firewall
iptables -N LOGDROP
iptables -A LOGDROP -m log --log-level info --log-prefix "IPTABLES" \
	-m limit --limit 5/m --limit-burst 10 -j LOG
iptables -A LOGDROP -j DROP

# block bad packets and http and ssh traffic from broken addresses
iptables -A INPUT -m conntrack --ctstate INVALID -j LOGDROP
iptables -t raw -I PREROUTING -m rpfilter -j LOGDROP
for addr in $broken; do
	iptables -A INPUT -p tcp -i $ext_if -s $addr --dport 80 -j REJECT
	iptables -A INPUT -p tcp -i $ext_if -s $addr --dport 443 -j REJECT
	iptables -A INPUT -p tcp -i $ext_if -s $addr --dport 22 -j REJECT
done

# allow established traffic to applications
iptables -I INPUT 1 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# allow new traffic to applications
iptables -A INPUT -m limit --limit 5/m --limit-burst 10 -m conntrack \
	--ctstate NEW -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -m limit --limit 5/m --limit-burst 10 -m conntrack \
	--ctstate NEW -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -m limit --limit 5/m --limit-burst 10 -m conntrack \
	--ctstate NEW -p tcp --dport 443 -j ACCEPT

# drop all other traffic
iptables -A INPUT -j DROP
```
