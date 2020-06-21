function Get-TCUserRoleMapping($UserIds){
    $UserRoleList = @()
    $counter = 0

    foreach($user in $UserIds){
        $userRoles = Get-TCUserRole -userID $user
        foreach($role in $userRoles){
            $userRole = "" | select UserId,RoleId,Scope
            $userRole.UserId = $user
            $userRole.RoleId = $role.roleid
            $userRole.Scope = $role.scope
            $UserRoleList += $userRole       
        }
        $counter ++
        Write-Progress -Activity "Collecting User Direct Role Details" -Status "Done : $counter of $($UserIds.Count)" -PercentComplete (($counter / $UserIds.Count) * 100)
    }
    return $UserRoleList
}