## Palo Alto

The Palo Alto firewall is a common and relatively user friendly hardware firewall solution.


### Lights Out

To disconnect a port, likely for the purposes of isolating the network from attack, use the following snippet with the desired interface to disconnect.

```paloalto
configure
set network interface ethernet <interface> link-state down
commit
```


### Basic Commands

The Palo Alto firewall works similar to Cisco systems in that the command line has various contexts it can be in. The default context gives access to basic network tools, such as ping or traceroute. To configure the firewall, use the `configure` context. While in the `configure` context, you can open various `edit` contexts that follow the hierarchical nature of the firewall configuration. For each `edit` context, it scopes the `set` command to those contexts so that the full path does not need to be specific for several set statements in a row. The `up` and `top` commands can travel up the hierarchy back to base contexts. Settings are not live until the `commit` command is run. You can use tab completion or the question mark key to complete written values and find potential options. The sections below will assume you are in the appropriate `edit` context given at the beginning of the section.


### Interfaces

To edit network interfaces, such as the IP and mask of a particular subnet, enter the `edit network interface` context.


#### Set Interfae Network

Use the following to set the interface to the `10.13.37.0/24` network with the address `10.13.37.3`.

```paloalto
edit ethernet <interface>
set layer3 ip 10.13.37.3/24
up
```


### Routers

To edit virtual routers, such as the default, enter the `top` context.


#### Add Interface to Router

Use the following to add an interface to a virtual router.

```paloalto
edit network virtual-router <name>
set interface <interface>
up
```


### Zones

To edit security zones, such as the LAN and DMZ, enter the `top` context.


#### Edit Zone Network

Use the following to set the interface for the named zone.

```paloalto
edit zone <name> network
set layer3 <interface>
up
up
```


### Rules

To edit security rules, such as traffic barriers between interfaces, enter the `edit rulebase security` context. Rules between zones are default deny and rules within zones are default allow.


#### Firewall Connections

The following rule prevents any connections to the firewall itself.

```paloalto
edit rulebase security banhammer
set from any to any destination <management address> action deny
up
```


#### DMZ and LAN Interaction

The following rule enables a connection between the DMZ and LAN under specific circumstances, here a MySQL connection from webapps to database.

```paloalto
edit rulebase security database
set from dmz to lan source <webapps> destination <database> application mysql service application-default action allow
up
```


#### Incoming Traffic

The following rule enables a connection between the public interface and LAN under specific circumstances, here an HTTP connection to webapps.

```paloalto
edit rulebase security package
set from public to lan destination <webapps> application web-browsing service application-default allow
up
```


#### Outgoing Traffic

The following rule enables outgoing communication to specific websites for package management and for DNS lookups.

```paloalto
edit rulebase security package
set from any to public destination [ <centos archive> <debian archive> ] application web-browsing
up
edit rulebase security dns
set from any to public destination <dns server> application dns
up
```
