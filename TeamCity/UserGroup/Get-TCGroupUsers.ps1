function Get-TCGroupUsers($GroupKey){
    
    $userListUrl = "$teamCityHost/app/rest/userGroups/key:$GroupKey"
    $userListURLresponse = Invoke-TCWebRequest -URL $userListUrl -Method Get

    $UserList = ([xml]$userListURLresponse.Content).group.users.user 
    
    return $UserList
}