## Bulk Users

The following scripts takes an accounts.csv file with headers 'Firstname,Lastname,SAM,Email' and adds them to the current active directory.

```powershell
$Users = Import-Csv -Path "accounts.csv"
foreach ($User in $Users)
{
    $Displayname = $User.Firstname + " " + $User.Lastname
    $UserFirstname = $User.Firstname
    $UserLastname = $User.Lastname
    $SAM = $User.SAM
    $UPN = $User.Email
    $Password = "CUCyber9."
    New-ADUser -Name "$Displayname" -DisplayName "$Displayname" -GivenName "$UserFirstname" -Surname "$UserLastname" -SamAccountName $SAM -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $true
}
```
