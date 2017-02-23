## Wireshark

Wireshark is a GUI and command line tool for network monitoring and analysis. You can use it to record and later analyze or recreate network traffic. You can also use it to find malicous traffic on the network. It can run with promiscuous mode, where all network traffic on the interface is recorded, or without it, where only network traffic originating from or going to the monitoring computer is recorded. It must be run as an administrator to capture traffic (`sudo -E wireshark-gtk` on Linux systems).


### Color Scheme

In the traffic pane, the traffic will be highlighted to correspond with different types of packets.

* Green - TCP traffic
* Dark Blue - DNS traffic
* Light Blue - UDP traffic
* Black - TCP packets with problems


### Filters

```wireshark
# bidirection capture
# capture IPv4 or IPv6 packets to and from a specific host
host 192.168.1.1

# capture packets to and from a subnet of IP addresses in CIDR notation
net 192.168.1.1/24 

# capture packets to and from a subnet of IP addresses in network mask notation
net 192.168.1.1 mask 255.255.255.0

# capture traffic only from one source
src net 192.168.1.1

# capture traffic only from a subnet of hosts in CIDR notation
src net 192.168.1.1/24

# capture packets from a range of IPs in subnet format
net 192.168.1.1 mask 255.255.255.0

# capture traffic on specific ports
port 21

# capture traffic for specific services
http
dns
ftp

# capture port range with specific protocol
tcp portrange 1-65535

# capture only IPv4 traffic
# useful when trying to observe traffic other than ARP and STP
ip

# capture only unicast traffic
# good for when you are trying to clear up noise on network
not broadcast and not multicast

# capture heartbleed attempts
tcp src port 443 and (tcp[((tcp[12] & 0xF0) >> 4 ) * 4] = 0x18) and (tcp[((tcp[12] & 0xF0) >> 4 ) * 4 + 1] = 0x03) and (tcp[((tcp[12] & 0xF0) >> 4 ) * 4 + 2] < 0x04) and ((ip[2:2] - 4 * (ip[0] & 0x0F)  - 4 * ((tcp[12] & 0xF0) >> 4) > 69)rc port 443 and (tcp[((tcp[12] & 0xF0) >> 4 ) * 4] = 0x18) and (tcp[((tcp[12] & 0xF0) >> 4 ) * 4 + 1] = 0x03) and (tcp[((tcp[12] & 0xF0) >> 4 ) * 4 + 2] < 0x04) and ((ip[2:2] - 4 * (ip[0] & 0x0F)  - 4 * ((tcp[12] & 0xF0) >> 4) > 69))
```
