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


### Rules

To edit security rules, such as traffic barriers between interfaces, enter the `edit rulebase security` context. Rules between zones are default deny and rules within zones are default allow.


#### Firewall Connections

The following rule prevents any connections to the firewall itself.

```paloalto
edit rules banhammer
set from any destination <firewall address> action deny
up
```


#### DMZ and LAN Interaction

The following rule enables a connection between the DMZ and LAN under specific circumstances, here a MySQL connection from webapps to database.

```paloalto
edit rules database
set from dmz to lan source <webapps> destination <database> application mysql action allow
up
```


#### Outgoing Traffic

The following rule enables outgoing communication to specific websites for package management and for DNS lookups.

```paloalto
edit rules package
set from any to public destination [ <centos archive> <debian archive> ] application web-browsing
up
edit rules dns
set from any to public destination <dns server> application dns
up
```
