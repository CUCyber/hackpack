 $Users = Import-Csv -Path "C:\Users\Administrator\Documents\scripts-morgan\account_csv.csv"            
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
