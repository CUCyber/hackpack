## Add Group

The following scripts takes an accounts.csv file with headers 'Firstname,Lastname,SAM,Email' and adds them to the current Active Directory 'Administrators' group.

```powershell
$Users = Import-Csv -Path "accounts.csv"

ForEach($user in $Users){
    Add-ADGroupMember -Identity Administrators -Member $user.SAM
}
```
