## AD-DNS - WIP

Windows does not give a special name for the DNS server, so it is commonly 
referred to as "AD-DNS."

__Installation:__
- CMD (WIN2008R2+): `dism /online /enable-feature /featurename:DNS-Server-Core-Role`
- Powershell: `Install-WindowsFeature -Name DNS`

### DNS Domains
 - Dns Names are based upon a heirachy
 - A full domain address, including the root, is a "Fully qualified domain name" or FQDN
   + Root level domain (11 of these) - ex: "*."
   + Top level domain - ex: "*.com"
   + Second level/business level - ex: "*.microsoft.com"
   + subdomain - ex: "*.technet.microsoft.com"
   + host/resource - ex "www.technet.microsoft.com"

### Resource Record Types
 - SOA - Sets authoritative domain server
 - A - map host name to ipv4 address
 - AAAA - map host name to ipv6 address
 - CNAME - Create alias - used to create multiple A records for different services to one ip
 - PTR - map ipv4 address to domain name (not required, but should be done according to RFC 1035)
 - DS - Delegation of signing - DNSSEC only
 - DnsKey - Contains public key for verifying signatures - DNSSEC only 
 - MX - specifies mail server for SMTP
 - NS - Sets dns servers available

_Note: Host and node are used interchangably._

__Add New Record:__ 
- CMD: `dnscmd.exe /recordadd <ZoneName> <HostName> <RecordType> <RecordData>`
- Powershell: 
    + A Record:
    `Add-DnsServerResourceRecordA
   [-AllowUpdateAny]
   [-CreatePtr]
   [-Name] <String>
   [-IPv4Address] <IPAddress[]>
   [-ComputerName <String>]
   [-TimeToLive <TimeSpan>]
   [-ZoneName] <String>
   [-AgeRecord]
   [-PassThru]
   [-ZoneScope <String>]
   [-VirtualizationInstance <String>]
   [-CimSession <CimSession[]>]
   [-ThrottleLimit <Int32>]
   [-AsJob]
   [-WhatIf]
   [-Confirm]
   [<CommonParameters>]`

    + AAAA Record:
    `Add-DnsServerResourceRecordAAAA
   [-AllowUpdateAny]
   [-CreatePtr]
   [-IPv6Address] <IPAddress[]>
   [-Name] <String>
   [-ComputerName <String>]
   [-TimeToLive <TimeSpan>]
   [-ZoneName] <String>
   [-AgeRecord]
   [-PassThru]
   [-ZoneScope <String>]
   [-VirtualizationInstance <String>]
   [-CimSession <CimSession[]>]
   [-ThrottleLimit <Int32>]
   [-AsJob]
   [-WhatIf]
   [-Confirm]
   [<CommonParameters>]`

    + CNAME Record:
     `Add-DnsServerResourceRecordCName
   [-HostNameAlias] <String>
   [-AllowUpdateAny]
   [-Name] <String>
   [-ComputerName <String>]
   [-TimeToLive <TimeSpan>]
   [-ZoneName] <String>
   [-AgeRecord]
   [-PassThru]
   [-ZoneScope <String>]
   [-VirtualizationInstance <String>]
   [-CimSession <CimSession[]>]
   [-ThrottleLimit <Int32>]
   [-AsJob]
   [-WhatIf]
   [-Confirm]
   [<CommonParameters>]`

    + DS Record: 
     `Add-DnsServerResourceRecordDS
   [-Name] <String>
   [-CryptoAlgorithm] <String>
   [-TimeToLive <TimeSpan>]
   [-AgeRecord]
   [-Digest] <String>
   [-DigestType] <String>
   [-KeyTag] <UInt16>
   [-ComputerName <String>]
   [-ZoneName] <String>
   [-PassThru]
   [-ZoneScope <String>]
   [-CimSession <CimSession[]>]
   [-ThrottleLimit <Int32>]
   [-AsJob]
   [-WhatIf]
   [-Confirm]
   [<CommonParameters>]`

    + DnsKey record:
        `Add-DnsServerResourceRecordDnsKey
   [-Name] <String>
   [-CryptoAlgorithm] <String>
   [-ZoneName] <String>
   [-TimeToLive <TimeSpan>]
   [-AgeRecord]
   [-Base64Data] <String>
   [-KeyProtocol <String>]
   [-ComputerName <String>]
   [-SecureEntryPoint]
   [-ZoneKey]
   [-PassThru]
   [-ZoneScope <String>]
   [-CimSession <CimSession[]>]
   [-ThrottleLimit <Int32>]
   [-AsJob]
   [-WhatIf]
   [-Confirm]
   [<CommonParameters>]`

    + MX record:
       `Add-DnsServerResourceRecordMX
   [-Name] <String>
   [-MailExchange] <String>
   [-Preference] <UInt16>
   [-ComputerName <String>]
   [-TimeToLive <TimeSpan>]
   [-ZoneName] <String>
   [-AgeRecord]
   [-AllowUpdateAny]
   [-PassThru]
   [-ZoneScope <String>]
   [-VirtualizationInstance <String>]
   [-CimSession <CimSession[]>]
   [-ThrottleLimit <Int32>]
   [-AsJob]
   [-WhatIf]
   [-Confirm]
   [<CommonParameters>]`
    
    + PTR Record:
     `Add-DnsServerResourceRecordPtr
   [-AllowUpdateAny]
   [-PtrDomainName] <String>
   [-Name] <String>
   [-ComputerName <String>]
   [-ZoneName] <String>
   [-TimeToLive <TimeSpan>]
   [-AgeRecord]
   [-PassThru]
   [-ZoneScope <String>]
   [-VirtualizationInstance <String>]
   [-CimSession <CimSession[]>]
   [-ThrottleLimit <Int32>]
   [-AsJob]
   [-WhatIf]
   [-Confirm]
   [<CommonParameters>]`

__Get DNS Records:__
 - cmd: `dnscmd.exe /enumrecords <ZoneName> <Hostname> 
    [/type <RecordType> <RecordData>]
    [/authority]
    [/glue]
    [/additional]
    [/node |/child |/startchild <ChildName>]
    [/continue]
    [/detail]`

 - Powershell: `Get-DnsServerResourceRecord
   [[-Name] <String>]
   [-ComputerName <String>]
   [-ZoneName] <String>
   [-Node]
   [-ZoneScope <String>]
   [-VirtualizationInstance <String>]
   [-Type] <UInt16>
   [-CimSession <CimSession[]>]
   [-ThrottleLimit <Int32>]
   [-AsJob]
   [<CommonParameters>]`

__Delete DNS Records:__
 - cmd: `dnscmd.exe /recorddelete <ZoneName> <NodeName> <RRType> <RRData> [/f]`
 
 - Powershell: `Remove-DnsServerResourceRecord
      [-ZoneName] <String>
      [-PassThru]
      [-ComputerName <String>]
      [-Force]
      [-ZoneScope <String>]
      [-VirtualizationInstance <String>]
      -InputObject <CimInstance>
      [-CimSession <CimSession[]>]
      [-ThrottleLimit <Int32>]
      [-AsJob]
      [-WhatIf]
      [-Confirm]
      [<CommonParameters>]`

### Zones
 - AD-DNS files its records by "zones"
 - Zones are anchored to a domain name
 - contains info about all hosts inside the domain
 - First record is an SOA
 - Zone records may be delegated, meaning the zone will contain a link to another DNS server elsewhere
 - Different types, refferring to same space:
   + Primary: zone to which all updates for the zone are made
   + Secondary: read only copy of primary
   + Stub: Read-only copy of dns servers for the domain

_Note: Secondary or stubs of a zone cannot be hosted on the primary server for that zone_

 - Process of replicating zone files is a *zone transfer*
   + Transfers can be made from primary and secondary servers
   + "*Master DNS Server*" is the source of the info
   + Transfers are made when master sends a notification to secondary servers when zone is changed or on refresh interval detailed in the SOA
   + 2 types: full (AXFR), incremental (IXFR)
   + Bing 4.93 & NT 4.0 support AXFR only

### DNS Query
 - Queries are sent client-to-server or server-to-server
 - Two types of queries:
   + Recursive: DNS will query forwarders
   + Iterative: DNS local information only, other dns server that might have the info
 - TTL - Time to Live - is time to cache info
   + Default: 60 minutes
 - Subnet prioritization
   + if multiple servers in multiple subnets, prioritizes your subnet first
   + Otherwise, is round robin
 - Root hints
   + Direct non-root DNS servers to root ones

### ENDS0
 - Extensions for DNS, advertises UDP packet size and allows packets over 512 bytes
 - Enabled in Windows 2003+ by default
 - To disable:
    + cmd: `REG ADD HKLM\System\CurrentControlSet\Services\DNS\Parameters /v EnableEDNS /t REG_DWORD /d 0x0`
    + PS : `New-ItemProperty -Path:"HKLM:\System\CurrentControlSet\Services\DNS\Parameters" -Name EnableEDNS -Type REG_DWORD -Value 0x0`

### Key Files
 - %systemroot%\System32\Dns\Boot - BIND .boot configuration file
 - %systemroot%\System32\Dns\Cache.dns - preloads server names cache
 - %systemroot%\System32\Dns\Root.dns - Root zone file -- appears only if server is root server
 - %systemroor%\System32\Dns\*zone_name_*.dns - used when stanard zone is added and configured
 - Primary zones are stored in Active Directory

### Configuration Steps


### Known Security Vulnerabilities


### Further Reading
 - How DNS Works: https://technet.microsoft.com/en-us/library/cc772774%28v=ws.10%29.aspx?f=255&MSPPError=-2147217396
 - DNSCMD: https://technet.microsoft.com/en-us/library/cc756116%28v=ws.10%29.aspx?f=255&MSPPError=-2147217396#BKMK_14
 - Powershell Module: https://docs.microsoft.com/en-us/powershell/module/dnsserver/Remove-DnsServerResourceRecord?view=win10-ps
 - Zone transfer notification: https://www.ietf.org/rfc/rfc1996.txt