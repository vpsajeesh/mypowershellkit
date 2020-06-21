function Get-TCUserList(){

    $userListUrl = "$teamCityHost/app/rest/users"
    $userListURLresponse = Invoke-TCWebRequest -URL $userListUrl -Method Get

    $UserList = ([xml]$userListURLresponse.Content).users.user 
    
    return $UserList
}