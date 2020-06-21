function Get-TCUserGroupRoleMapping(){

    $users = Get-TCUserList
    $totalCount = $users.Count
    $counter = 0
    $userDetailsList = @()
    foreach($user in $users){    
    
        $uDtls = Get-TCUser -userID $user.Id

        foreach($group in $uDtls.Groups.group ){        
            $GroupRoles = Get-TCGroupRoles -GroupKey $group.key
            foreach($role in $GroupRoles){
                $userDetails = "" | select Id,Name,UserName,GroupName,Scope,GroupKey,RoleId
                $userDetails.Id = $user.id
                $userDetails.Name = $user.Name
                $userDetails.UserName =$user.username
                $userDetails.GroupName =$group.name     
                $userDetails.GroupKey =$group.key         
                $userDetails.Scope = $role.scope
                $userDetails.RoleId = $role.roleId
                $userDetailsList += $userDetails
            }
        }

        $counter ++
        Write-Progress -Activity "Collecting User Group Details" -Status "Done : $counter of $totalCount" -PercentComplete (($counter / $totalCount) * 100) 
    }

    return $userDetailsList
}