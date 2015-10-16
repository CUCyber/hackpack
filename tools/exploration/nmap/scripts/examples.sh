# Most common Options

# Ping scan of a IPv4 Network
nmap -sn 192.168.1.0/24

# Agressive scan of a IPv4 host
nmap -T4 -A 192.168.1.1/32

# Agressive scan of a hostname resolved via dns
nmap -T4 -A www.foobar.com

# Agressive scan of a IPv6 host
nmap -6 -T4 -A 2::dead:beaf:cafe/128

# Agressive scan of a file of hosts/networks separated by newlines
nmap -T4 -A -iL inputfile.txt
