## Windows Filesystem Heirarchy
* Windows file heirarchy has evolved much from initial to most recent.
	- The data below is accurate for Windows 10.

* `C:\`
	- Is typically the root drive where the system is installed and runs from.
    - Note the "\\" - recent Windows releases aren't stingy, but older/proper file formatting requires the use of "\\"
		+ Makes switching between Unix and Windows a huge pain
    - Usually location of Hibernation file (`Hiberfil.sys`) and pagefile (`pagefile.sys`).
    - Often, services will run from a `tmp` or `inetpub` subdirectory here
* `C:\Users` _- Windows XP and later_
	- Contains user documents, data, and preferences
    - Note especially the AppData folders. %AppData%\local\temp is a dangerous place.
* `C:\Program Files`
	- The default installation location on x86 systems and installation location for WOW64
    - Present in all versions of Windows
* `C:\Program Files (x86)` _- x64 Windows only_
	- Default install location for x86 applications on x64 installations
* `C:\ProgramData` _- Windows XP and later_
	- Hidden folder, where applications store system information
    - Usually contains download info
    - Semi-popular hiding location for malware and backdoors
* `C:\Windows.old`
	- After OS upgrades or restores, user/system files are copied here
    - Delete if present.
* `C:\WINDOWS`
	- Contains _most_ system files
    - Contained user files in Windows 2000 and earlier
    - Contains .ini configuration files - used by Windows 2000 and earlier
		+ Compatibility for 16-bit applications
    - Notable executables:
		+ explorer.exe - Opens folder browser, but also is backend for desktop and taskbar
        + regedit.exe  - gui editing of the windows registry
        + notepad.exe - default Windows text editor
        + write.exe - Basic document editor
        + winhlp32.exe - shows exe help _- x64 Windows only_
* `C:\WINDOWS\BOOT`
	- Files used for booting and displaying boot information
    - Critical for system startup
* `C:\WINDOWS\diagnostics`
	- Contains powershell diagnostic scripts
* `C:\WINDOWS\INF`
	- Contains driver configuration data
* `C:\WINDOWS\Minidump`
	- location of memory dumps - contains memory often before crashes -- useful for troubleshooting
* `C:\WINDOWS\Logs`
	- Contains more recent system logs (Windows 7+) for DISM, WindowsUpdate, etc.
* `C:\WINDOWS\Security`
	- Contains security logs as configured by GPO
* `C:\WINDOWS\ServiceProfiles`
	- Contains service account data in "Users" style directories
* `C:\WINDOWS\SYSTEM`
	- Used to contain system files, but has progressively been replaced by System32
* `C:\WINDOWS\SYSTEM32`
	- The core of the operating system.
    - Watch for file spoofing, code injection, kernel crashes, driver corruptions, etc.
    - Contents change so often it's hard to tell what's legitimate
    - Contains core executables (Windows Admin tools, framework, etc.)
	- Notable Subdirectories:
		+ `Boot` - Contains core windows loaders and EFI
        + `config` - Drivers, SAM, and SYSTEM running files
        + `drivers` - Base system drivers, default drivers, network drivers - core driver location
        + `drivers\etc` - legacy, but still used network configuration files
        + `Printing_Admin_Scripts\en-US` - Contains printer setup scripts
		+ `spool` - Contains Print server tools, drivers, daemons, etc.
        + `Tasks` - Task scheduler startup entries stored here
        + `WindowsPowershell` - Core powershell (1.0) files
        + `winevt` - contains all system/application logs
    - Notable executables:
		+ ARP.EXE - windows address resolution protocol
        + auditpol.exe - commandline editing of auditing policy
        + bash.exe - _Windows Subsystem For Linux_
        + bcdboot.exe - gets boot configuration files _Windows Vista and Later_
        + bcdedit.exe - edits boot configuration Data store _Windows Vista and Later_
        + bitsadmin.exe - Background transfer service _(Deprecated)_
        + bootcfg.exe - Edits boot.ini _Windows XP and earlier_
        + bootim.exe - Windows Boot recovery options
        + bootsect.exe - MBR Restoration tool
        + cacls.exe - Commandline editing of ACLs _(Deprecated)_
        + icacls.exe - modern commandline editing of ACLs
        + certreq.exe - creates request to certificate authority
        + certutil.exe - management of certificate store - can edit registry
        + change.exe - Change user, logon, and port settings!
        + chkdsk.exe - Check disk for errors
        + chkntfs.exe - checks disk at boot.
        + cipher.exe - Edits and displays ntfs encryption locations/settings
        + cmd.exe