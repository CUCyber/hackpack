## pf


### Config Files

pf references the following files:

* '/etc/rc.conf' - as with all servies, pf must be enabled here
* '/etc/pf.conf' - pf configuration file


### Commands

pf uses the following binaries:

* `pfctl -f /etc/pf.conf` - load the firewall configuration
* `pfctl -sa` - see the current configuration status
* `kldload pf` - load the pf kernel module


### Filtering

All of the configuration for pf is stored in '/etc/pf.conf'. There is no way to modify the running configuration except to overwrite the running configuration with the saved configuration. Unlike other firewalls, the last rule to match will be the rule that is applied. This behavior can be overridden by using the `quick` keyword.


### Example Configuration

```pf
# adapted from bsdnow tutorial

# variables for convenience
ext_if = "em0"
broken="224.0.0.22 127.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12, \
		10.0.0.0/8, 169.254.0.0/16, 192.0.2.0/24, \
		192.0.2.0/24, 198.51.100.0/24, 203.0.113.0/24, \
		169.254.0.0/16, 0.0.0.0/8, 240.0.0.0/4, 255.255.255.255/32"
# use a default drop policy
set block-policy drop

# skip the local loopback interface
set skip on lo0

# block invalid packets
match in all scrub (no-df max-mss 1440)
block in all
pass out quick on $ext_if inet keep state
antispoof quick for ($ext_if) inet

# block ipv6 if it is not needed
block out quick inet6 all
block in quick inet6 all

# block any packet we can't find a valid route back to
block in quick from { $broken urpf-failed no-route } to any
block out quick on $ext_if from any to { $broken no-route }

# block bad actors
table <childrens> persist
block in log quick proto tcp from <childrens> to any

# block Chinese address to ssh and web
table <chuugoku> persist file "/etc/cn.zone"
block in quick proto tcp from <chuugoku> to any port { 80 22 }

# allow traffic thought the firewall
pass in on $ext_if proto tcp from any to any port 80 flags S/SA synproxy state
pass in on $ext_if proto tcp from 1.2.3.4 to any port { 137, 139, 445, 138 }
pass in on $ext_if proto tcp to any port ssh flags S/SA keep state \
(max-src-conn 5, max-src-conn-rate 5/5, overload <childrens> flush)
pass inet proto icmp icmp-type echoreq

# adapted from the http://www.bsdnow.tv/tutorials/pf
# which is distrusted under CC-BY-SA
```
