## Immediate Steps
 __1. Disable RDP__

CMD: `reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f`

PS : `Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name fDenyTSConnections -Value 1`



__2. Enable Firewall__


__3. Change Password__


__4. Disable SMBv1__


__5. Set Ipv4 Address__

CMD: `netsh.exe interface ipv4 set address name=<STR NAME> [static <ip addr> <mask> <gateway>]|dhcp`

__6: Set DNS Server__

CMD: `netsh.exe interface ipv4 set dns name=<STR NAME> static <IP ADDR> [index=<#>]`

