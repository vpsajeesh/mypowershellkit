function Get-TCUserRole($userID){

    $userRoleUrl = "$teamCityHost/app/rest/users/id:$userID/roles"
    $userRoleURLresponse = Invoke-TCWebRequest -URL $userRoleUrl -Method Get

    $UserRole = ([xml]$userRoleURLresponse.Content).roles.role 
    
    return $UserRole
}