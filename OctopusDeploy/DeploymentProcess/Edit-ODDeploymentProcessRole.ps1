function Edit-ODDeploymentProcessRole($ProjectName, $RoleToRemove, $NewRoleName, $StepNames){
    
    $project = Get-ODProject -projectName $ProjectName

    $StepNameList = $StepNames -split ","

    $deploymentProcess = $octo.DeploymentProcesses.Get($project.DeploymentProcessId)
    $upate = 0
    foreach ($step in $deploymentProcess.Steps  | Where-Object { ($_.Name -in $StepNameList -and $StepNameList) -or (-not $StepNameList)} )
    {
        
        [System.Collections.ArrayList]$ExistingRoles = $step.Properties["Octopus.Action.TargetRoles"].Value -Split ","
        [System.Collections.ArrayList]$ExistingRolesCopy = $step.Properties["Octopus.Action.TargetRoles"].Value -Split ","

        If($RoleToRemove){            
           If($ExistingRoles -contains $RoleToRemove){
                $ExistingRoles.Remove($RoleToRemove)
                $upate ++
           }
        }

        if($NewRoleName){
            If($ExistingRoles -notcontains $NewRoleName){
                $ExistingRoles.Add($NewRoleName)
                $upate ++
            }                        
            
        }

        if($ExistingRoles.count -gt 0){

            $step.Properties["Octopus.Action.TargetRoles"] = $ExistingRoles -join ','
            
        }
    }

    if($upate -gt 0){
            $octo.DeploymentProcesses.Modify($deploymentProcess)
            Write-Output "Successfully updated Role!"
        
    }
    else{
        Write-Output "No changes to update Role!"
    }
}