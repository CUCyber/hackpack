## Nmap

Nmap is a network exploration tool, port scanner, and service scanner. It is useful for preforming host enumeration on IPv4 networks and auditing ports and services on specific hosts on IPv4 and IPv6 networks.


### Common Options

There are several main use cases and common options here:

```sh
#!/bin/sh
# most common options

# ping scan of a IPv4 network
nmap -sn 192.168.1.0/24

# agressive scan of a IPv4 host
nmap -T4 -A 192.168.1.1/32

# agressive scan of a hostname resolved via dns
nmap -T4 -A www.foobar.com

# agressive scan of a IPv6 host
nmap -6 -T4 -A 2::dead:beaf:cafe/128

# agressive scan of a file of hosts/networks separated by newlines
nmap -T4 -A -iL inputfile.txt
```


#### Host Discovery Options

For host discovery, the most important flag is `-sn`. It sends an ICMP ECHO to each target host. In IPv4 networks, this is a fast and easy way to enumerate hosts for a deeper scan.

In IPv6 networks, the address space is probably too large to do this effectively. On solution in this case to examine the network switch MAC table or to use tcpdump or wireshark to sniff for packets.

To conduct discovery using different types of packets use the `-P{n,S,A,U,Y}` option which uses no pings, SYN, ACK, UDP, and SCTP packets respectively.


#### Port Scanning Options

By default, Nmap scans the 1000 most commonly used ports. To use Nmap to scan for specific ports, use the `-p` flag to specify which ports to scan. It accepts hyphen separated ranges and comma separated lists. To scan all ports, use the --allports long option. To use a different type of packets use the `-s{S,T,A,W,U,Y}` option which tests with SYN, TCP connect, ACK, UDP, and SCTP INIT packets respectively.


#### Service Scanning Options

There are several commons flags to use here:

* `-O` will run OS detection against the target
* `-sV` will run service version detection against the target
* `-sC` will run common default scripts against the target to detect various things
* `--script="<script_name>"` will specify a script or group of scripts to run against the targets
* `-A` will enable OS detection, version detection, script scanning, and traceroute

Scripts that are available can often be found the '/usr/share/nmap' directory. Refer to these for examples on how to write scripts.


#### Timing and Optimization

Nmap has a series of timing and optimizations that can be run. The most useful is -T[1-5] which specifies how quickly packets are to be sent, 1 is the slowest and 5 is the fastest. You can also specify max retries via the --max-retries long option. You can also specify max timeout via the --host-timeout long option.


#### Evasive Options

If you are running Nmap offensively, there are several flags that control how evasive Nmap behaves. These allow for spoofing of IP address (`-S`) and MAC address (`--spoof-mac`) and for setting various options for sending custom packets.


#### Output Options

There are various output options the most important are:

* `-oN <file_name>` will send normal output to a file
* `-oG <file_name>` will send grep-able output to a file
* `-oX <file_name>` will output XML to a file
