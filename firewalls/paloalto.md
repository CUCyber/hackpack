## Palo Alto


### Lights Out

To disconnect a port, likely for the purposes of isolating the network from attack, use the following snippet with the desired interface to disconnect. To get completion, press 'Tab', and to get suggestions or available interfaces, press '?'.

```paloalto
configure
set network interface ethernet <interface> link-state down
commit
```


### Basic Commands

The Palo Alto firewall works similar to Cisco systems in that the command line has various states it can be in. The default state gives access to basic network tools, such as ping or traceroute. To configure the firewall, use the `configure` context. While in the `configure` context, you can open various `edit` contexts that follow the hierarchical nature of the firewall configuration. The sections below will assume you are in the appropriate `edit` context given at the beginning of the section.


### Rules

To edit security rules, such as traffic barriers between interfaces, enter the `edit rulebase security` context.


#### Security

```paloalto
```


#### Hosts

```paloalto
```
