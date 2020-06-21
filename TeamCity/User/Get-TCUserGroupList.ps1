function Get-TCUserGroupList(){
    
    $userGroupsListUrl = "$teamCityHost/app/rest/userGroups"
    $userGroupsListURLresponse = Invoke-TCWebRequest -URL $userGroupsListUrl -Method Get

    $UserGroupList = ([xml]$userGroupsListURLresponse.Content).groups.group 
    
    return $UserGroupList
}