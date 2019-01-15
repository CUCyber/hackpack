## pfSense

pfSense is a free firewall and routing software.


### Lights Out

```php
parse_config(true);
$config['interfaces']['wan']['enable'] = false;
write_config();
exec
```


### Recording

```php
record <filename>
<commands>
stoprecording
showrecordings
```


### Viewing Configuration

```php
parse_config(true);
print_r($config);
exec
```


### Creating Rules

```php
parse_config(true);
$rule = Array(
    "type" => "pass",
    "ipprotocol" => "inet",
    "protocol" => "<tcp|udp|icmp|any>",
    "descr" => "<DESCRIPTION>",
    "interface" => "<wan|lan|INTERFACE>",
    "tracker" => <UNIQUE_ID>,
    "source" => Array("<address|network|any>" => "<IP|CIDR|NONE>", "port" => "<PORT>"),
    "destination" => Array("<address|network|any>" => "<IP|CIDR|NONE>", "port" => "<PORT>"),
);
array_push($config['filter']['rule'], $rule);
print_r($config);
write_config();
exec
```


#### Example

```php
parse_config(true);
$rule = Array(
    "type" => "pass",
    "ipprotocol" => "inet",
    "protocol" => "tcp",
    "descr" => "Allow 22 to 192.168.0.2",
    "interface" => "wan",
    "tracker" => 01283912,
    "source" => Array("any" => ""),
    "destination" => Array("address" => "192.168.0.2", "port" => "22"),
);
array_push($config['filter']['rule'], $rule);
print_r($config);
write_config();
exec
```
