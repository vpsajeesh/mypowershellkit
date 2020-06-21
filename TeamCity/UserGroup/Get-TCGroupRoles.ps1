function Get-TCGroupRoles($GroupKey){
    
    $GroupRoleUrl = "$teamCityHost/app/rest/userGroups/key:$GroupKey/roles"
    $GroupRoleUrlresponse = Invoke-TCWebRequest -URL $GroupRoleUrl -Method Get

    $GroupRoles = ([xml]$GroupRoleUrlresponse.Content).roles.role 
    $GroupRoleList = @()
    foreach($role in $GroupRoles){
        $gRole ="" | select RoleId,Scope,GroupKey
        $gRole.RoleId = $role.roleId
        $gRole.Scope = $role.scope
        $gRole.GroupKey = $GroupKey
        $GroupRoleList += $gRole
    }

    return $GroupRoleList
}