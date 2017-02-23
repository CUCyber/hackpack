## Wireshark

Wireshark is a GUI/Command line tool for network monitoring. This is a tool you can run to recreate network traffic (network replay). It can also be used to discover malicious traffic on a network. 


### Running it on windows

Run Wireshark as an administrator to listen on your devices, you do not need to run promiscuous mode unless you are trying to capture all traffic on the network


### Running on Linux

Run Wireshark with "sudo -E"

```wireshark
sudo -E Wireshark-gtk
```

### Interface

Select the interface you would like Wireshark to listen on. In a competition this will typically be the ethernet interface

Examples:
```wireshark
eth0, eth1, virt-eth0
```

### Color Scheme

In the traffic pane the traffic will be highlighted to correspond with different formats the following are the meanings

Green = TCP traffic
Dark Blue = DNS traffic
Light Blue = UDP traffic
Black = TCP packets with problems

### Filters

```wireshark
#Bi direction capture
#Capture packets to and from a specific host IPv4 or IPv6 format
host 192.168.1.1

#Capture packets to and from a range of IPs in CIDR format
net 192.168.1.1/24 

#Capture packets to and from a range of IPs in subnet format
net 192.168.1.1 mask 255.255.255.0

#Traffic from one source only capture
src net 192.168.1.1

#Traffic from a range of hosts only capture CIDR format
src net 192.168.1.1/24

#Capture packets from a range of IPs in subnet format
net 192.168.1.1 mask 255.255.255.0

#Capture specific ports (DNS example)
port 53

#Capture service
http
dns
ftp
ssh

#Capture port range with specific protocol (all ports)
tcp portrange 1-65535

#Capture only IPv4 traffic
#This can be useful when trying to observe traffic other than ARP and STP
ip

#Capture only unicast traffic
#Good for when you are trying to clear up noise on network
not broadcast and not multicast

#Capture Heartbleed attempts
tcp src port 443 and (tcp[((tcp[12] & 0xF0) >> 4 ) * 4] = 0x18) and (tcp[((tcp[12] & 0xF0) >> 4 ) * 4 + 1] = 0x03) and (tcp[((tcp[12] & 0xF0) >> 4 ) * 4 + 2] < 0x04) and ((ip[2:2] - 4 * (ip[0] & 0x0F)  - 4 * ((tcp[12] & 0xF0) >> 4) > 69)rc port 443 and (tcp[((tcp[12] & 0xF0) >> 4 ) * 4] = 0x18) and (tcp[((tcp[12] & 0xF0) >> 4 ) * 4 + 1] = 0x03) and (tcp[((tcp[12] & 0xF0) >> 4 ) * 4 + 2] < 0x04) and ((ip[2:2] - 4 * (ip[0] & 0x0F)  - 4 * ((tcp[12] & 0xF0) >> 4) > 69))
```
