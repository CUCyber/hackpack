## Postfix

Postfix is a secure replacement for Sendmail. It features very strong process and privilege separation while keeping an interface roughly consistent with Sendmail. It should work out of the box for local mail delivery and relaying given the mail hostname.


### Full MTA


#### /etc/postfix/main.cf

```postfix
myhostname = [hostname]
```


### Send Only

Postfix should be used in place of Sendmail for the case of sending emails. It is easy to install and for send-only has minimal required configuration.


#### /etc/postfix/main.cf

Apply the below configuration where the original options are in the main configuration file. These will only allow connections from localhost and disable local delivery.

```postfix
inet_interfaces = loopback-only
local_transport = error:local delivery is disabled
```
