## Firewall Basics

Firewalls are essentially sets of rules that allow network traffic in and out of a machine. In general, firewalls should be configured to allow the minimum required access. For Windows, the firewall is called Windows Firewall. For Linux, iptables is the built-in low-level firewall and ufw and firewalld are the most common high-level firewalls. For BSD, pf, the base of the pfSense enterprise firewall, is the default. For dedicated equipment, such as the Cisco ASA, custom firewalls or firewalls based on Linux and on occasion BSD are common.

In general, there are 3 major elements of firewall security:

* Use a default reject policy to avoid admitting unwanted traffic.
* Open only the required ports to make the services to work.
* Log any unusual traffic that hits the firewall.


### Zones

Zones are distinct and physically or virtually separated portions of the network. A class example is the difference between LAN and WAN. Generally these are connected to ports on the firewall, but sometimes Virtual LANs or VLANs allow connecting multiple segregated zones to one port via hardware that supports it.


#### Common Zones

* DMZ (Demilitarized Zone) - separated zone that has no access to internal network
* WAN (Wide Area Network) - zone representing your upstream network connection, generally has your internet connection
* LAN (Local Area Network) - internal network that needs strict separation and access controls


### Rules

TODO


### Routes

TODO


## NAT

TODO
