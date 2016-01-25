$Users = Import-Csv -Path "C:\Users\Administrator\Documents\scripts-morgan\account_csv.csv" 

ForEach($user in $Users){
    Add-ADGroupMember -Identity Administrators -Member $user.SAM
}
