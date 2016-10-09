## FirewallD


### Config Files

FirewallD references the following directories of files:

* /usr/lib/firewalld - where package default rules reside
* /etc/firewalld - where user overrides rules reside


### Commands

FirewallD uses only the `firewall-cmd` binary.


### Filtering

FirewallD is the new Linux firewall from RedHat. It provides a usability layer on top of iptables by focusing on zones and services. FirewallD therefore inherits iptables's first match rule.


#### Zones

Zones are affiliated with source addresses or interfaces. Zones have short names they are referenced by.

The following zone example affects all incoming traffic with the enp0s3 interface. It allows HTTPS traffic defined in the /usr/lib/firewalld/services/https.xml or overwritten in /etc/firewalld/services/https.xml. It also blocks traffic on the 10.0.0.0/8 subnet by dropping and logging the packets.

```xml
<?xml version="1.0" encoding="utf-8"?>
<zone>
	<short>Public</public>
	<description>This is our external interface</description>
	<interface name="enp0s3"/>
	<service name="https"/>
	<rule family="ipv4">
		<source address="10.0.0.0/8"/>
		<log>
			<limit address="5/m"/>
		</log>
		<drop/>
	</rule>
</zone>
```


#### Services

Services define the ports and protocols that will be used by an application. Services have short names they are referenced by.

The following service example allows traffic on TCP port 21. It uses a kernel module to help track and filter the traffic. This is not required for all modules, but is used for some services such as FTP.

```xml
<?xml version="1.0" encoding="utf-8"?>
<service>
	<short>FOO</short>
	<description>Foo is a program that allows bar</description>
	<port protocol="tcp" port="21"/>
	<module name="nf_conntrack_foo"/>
</service>
```


### Example Configuration

```sh
#!/bin/bash

# get the name of the device used for the default route
ext_if=$(ip route | head -n 1 | awk '{print $5}')

# list of devices that should be blocked on the external interface
# WARNING! assumes that there are separate interfaces
#          for the external network
# NOTE the 192.168.0.0/16 subnet should be excluded
#      if there is only one interface
broken="224.0.0.22 127.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12, \
		10.0.0.0/8, 169.254.0.0/16, 192.0.2.0/24, \
		192.0.2.0/24, 198.51.100.0/24, 203.0.113.0/24, \
		169.254.0.0/16, 0.0.0.0/8, 240.0.0.0/4, 255.255.255.255/32"

firewall-cmd --zone=public --add-interface=$ext_if

for addr in $broken; do
	firewall-cmd --zone=public \
		--add-rich-rule="rule family='ipv4' service=ssh \
		source address=\"$addr\" log limit value='5/m' drop"
	firewall-cmd --zone=public \
		--add-rich-rule="rule family='ipv4' service=http \
		source address=\"$addr\" log limit value='5/m' drop"
	firewall-cmd --zone=public \
		--add-rich-rule="rule family='ipv4' service=https \
		source address=\"$addr\" log limit value='5/m' drop"
done

firewall-cmd --zone=public --add-service=ssh
firewall-cmd --zone=public --add-service=http

firewall-cmd --direct --add-rule ipv4 filter INPUT_direct 0 \
    -p tcp --dport ssh -m state --state NEW -m recent --set
firewall-cmd --direct --add-rule ipv6 filter INPUT_direct 0 \
    -p tcp --dport ssh -m state --state NEW -m recent --set
firewall-cmd --direct --add-rule ipv4 filter INPUT_direct 1 \
    -p tcp --dport ssh -m state --state NEW -m recent --update \
    --seconds 30 --hitcount 6 -j REJECT --reject-with tcp-reset
firewall-cmd --direct --add-rule ipv6 filter INPUT_direct 1 \
    -p tcp --dport ssh -m state --state NEW -m recent --update \
    --seconds 30 --hitcount 6 -j REJECT --reject-with tcp-reset

firewall-cmd --runtime-to-permanent
```
