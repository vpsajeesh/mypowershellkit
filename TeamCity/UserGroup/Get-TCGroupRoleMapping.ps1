function Get-TCGroupRoleMapping(){
    
    $counter = 0
    $GroupRoleMappings = @()
    $UserGroupList = Get-TCUserGroupList
    foreach($ug in $UserGroupList){
        $groupRoles = Get-TCGroupRoles -GroupKey $ug.Key

        foreach($grole in $groupRoles){
            $groupRoleMapping = "" | select GroupKey,RoleId,Scope
            $groupRoleMapping.GroupKey = $ug.key
            $groupRoleMapping.RoleId = $grole.RoleId
            $groupRoleMapping.Scope = $grole.Scope
            $GroupRoleMappings += $groupRoleMapping
        }

        $counter ++
        Write-Progress -Activity "Collecting Group Role Details" -Status "Done : $counter of $($UserGroupList.Count)" -PercentComplete (($counter / $UserGroupList.Count) * 100)
    }

    return $GroupRoleMappings
}






