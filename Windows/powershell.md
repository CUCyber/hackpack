## Powershell
 - Powershell is Microsoft's answer to the sysadmin cries for configuration

### Installation
 - Windows Powershell comes installed by default on Windows 7 and higher, and Windows Server 2012 or higher
 - Windows 2008R2+ Server-Core:
   1. Install `NetFx2-ServerCore` with DISM
   2. Install `MicrosoftWindowsPowershell` with DISM
   3. Install `NetFx2-ServerCore-WOW64` with DISM
   4. Install `MicrosoftWindowsPowershell-WOW64` with DISM
   5. Add Windows Powershell to the path: `PATH C:\Windows\System32\WindowsPowershell\v1.0;%PATH%`
 
 - For Windows Vista and Server 2008, only Powershell 1.0 is a feature, and only for non-serverCore
 - For Windows Server 2003 and XP SP2 and SP3, Powershell is an installable application

### Useful Commands