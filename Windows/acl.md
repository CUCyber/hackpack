## Access Control Lists (ACL)
 - Comprised of access control entries (ACE)
   + Each identifies a trustee (account or logon session by SID) and access rights
   +  Can be allowed, denied, or audited
 - Controls access to any securable object
 - Each ACL target is assigned a GUID
 - Are a component of property sets in Windows 2000+
 - Editing:
    + CMD: `icacls.exe`
    + PS : `((Get-Item <Path>)).GetAccessControl('Access')).Access`

### Discretionary Access Control List (DACL)
 - Controls allow or deny access to securable object
 - Also controls process access
 - If no DACL is set, then the default is full control for Everyone
 - If DACL is set, but has no entries, denies all

### System Access Control List (SACL)
 - Enables administrators to log access
 - Generate on access success or failure or both

### Key Files
 - `cacls.exe` - cmd acl editing in Windows 2003 and earlier
 - `icacls.exe` - better acl editing in Windows 2003 Sp2+
 - pretty much any directory

### Configuration Steps
