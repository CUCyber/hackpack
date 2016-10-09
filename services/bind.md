## BIND

BIND is a common, featured DNS server. To make it more secure and less vulnerable to attacks, it is recommended to only run BIND as an authoritative nameserver and not as a recursive nameserver.


### Config Files

The configuration for BIND is usually stored in either:

* /etc/bind/ (Debian-based distributions)
* /etc/named/ (other distributions)
* /etc/named.conf (RedHat-based distributions)
* /var/named/ (RedHat-based distributions)

Utilize the named-checkconf utility to check configuration before applying it.


### Example Configuration

Below is a set of example configuration files for securely configuring BIND as an authoritative nameserver with forward and reverse records.


#### /etc/named.conf

```bindconf
options {
   # disable zone transfers
   allow-transfer { "none"; };
   version "none";
   fetch-glue no;

   # if we have another DNS recursor, disable queries and recursion
   allow-query { "none"; };
   recursion no;

   # if we are a DNS recursor, only allow queries
   # from the local network
   #allow-query { 10.0.0.0/24; localhost; };
};

# if we are a DNS recursor,
# set forwarding addresses to another nameserver
#forwarders {
#    8.8.8.8;
#    8.8.4.4;
#};
```


#### /var/named/example.com.conf

```bindconf
# replace example.com with the actual domain
zone "example.com" {
    type master;
    # rhel puts these in /var/named
    file "/etc/bind/zones/db.example.com";

    # allow queries to this zone from anywhere
    allow-query { any; };
};

# 10.0.0.0/24 subnet, put address octets backwards
zone "0.0.10.in-addr.arpa" {
    type master;
    # rhel puts these in /var/named
    file "/etc/bind/zones/db.10.0.0";

    # allow queries to this zone from anywhere
    allow-query { any; };
};
```


#### /var/named/db.example.com

```bind
$ORIGIN example.com.

; TTL of 10 minutes for quick change during competitions
$TTL    600

; hostmaster.example.com. is the email hostmaster@example.com
@       IN      SOA     ns1.example.com. hostmaster.example.com. (
                                         1       ; Serial
                                         600     ; Refresh
                                         600     ; Retry
                                         2419200 ; Expire
                                         600     ; Negative Cache TTL
                                                 ; (how long to cache
                                                 ;  negative (e.g. NXDOMAIN)
                                                 ;  responses)
                                         )
        IN      NS      ns1         ; this box
        IN      MX  10  mail        ; mail box
        IN      A       10.0.0.103  ; www box (resolve example.com
                                               to the same address as
                                               www.example.com)

ns1     IN      A       10.0.0.101
mail    IN      A       10.0.0.102
www     IN      A       10.0.0.103
```


#### /var/named/db.10.0.0

```bind
; put address octets backwards
$ORIGIN 0.0.10.in-addr.arpa.

; TTL of 10 minutes for quick change during competitions
$TTL    600

; hostmaster.example.com. is the email hostmaster@example.com
@       IN      SOA     ns1.example.com. hostmaster.example.com. (
                                         1       ; Serial
                                         600     ; Refresh
                                         600     ; Retry
                                         2419200 ; Expire
                                         600     ; Negative Cache TTL
                                                 ; (how long to cache
                                                    negative (e.g. NXDOMAIN)
                                                    responses)
                                         )
    	IN      NS      ns1         ; this box

; if on a bigger subnet, put octets backwards (i.e. 101.0.0)
101     IN      PTR     ns1         ; 10.0.0.101
102     IN      PTR     mail        ; 10.0.0.102
103     IN      PTR     www         ; 10.0.0.103
```
