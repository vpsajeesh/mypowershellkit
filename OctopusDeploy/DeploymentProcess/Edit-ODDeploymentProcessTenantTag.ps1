function Add-ODTenantTag($StepAction, $TenantTag){
    
    $updateCount = 0
    If($StepAction.TenantTags -match $TenantTag.CanonicalTagName){
        Write-Host "Tag $($TenantTag.CanonicalTagName) found in step $($action.Name)"
    }
    else{
            
        Write-Host "Tag $($TenantTag.CanonicalTagName) misssing in step $($action.Name). Adding now!"
        try{
            $StepAction.TenantTags.Add($TenantTag.CanonicalTagName) | Out-Null
            $updateCount ++
        }
        catch{
            throw "Error Happened!"
        }
    }

    return $updateCount
}

function Remove-ODTenantTag($StepAction, $TenantTag){
    
    $updateCount = 0
    If($StepAction.TenantTags -match $OldTenantTag.CanonicalTagName){
        Write-Host "Tag $($OldTenantTag.CanonicalTagName) found in step $($action.Name).. Removing!"
        try{
            $StepAction.TenantTags.Remove($OldTenantTag.CanonicalTagName) | Out-Null
            $updateCount ++
        }
        catch{
            throw "Error Happened!"
        }
    }
    else{
            
        Write-Host "Tag $($TenantTag.CanonicalTagName) misssing in step $($action.Name)."
                
    }

    return $updateCount
}

function Edit-ODDeploymentProcessTenantTag($ProjectName, $TenantTagToRemove, $NewTenantTag, $StepNames){
    
    if(-not ($TenantTagToRemove -or $NewTenantTag)){
        throw "TenantTag Parameter is empty!"
    }

    if($TenantTagToRemove){
        $OldTenantTag = Get-ODTenantTag -TenantTag $TenantTagToRemove
    }

    if($NewTenantTag){
        $TenantTag = Get-ODTenantTag -TenantTag $NewTenantTag
    }
    

    $project = Get-ODProject -projectName $ProjectName
    
    $deploymentProcess = $octo.DeploymentProcesses.Get($project.DeploymentProcessId)
    
    $StepNameList = $StepNames -split ","

    $updated = 0
    foreach($step in $deploymentProcess.Steps){

       foreach($action in  $step.Actions | Where-Object { ($_.Name -in $StepNameList -and $StepNameList) -or (-not $StepNameList)} ){
        
            if($TenantTag){
                $result = Add-ODTenantTag -StepAction $action -TenantTag $TenantTag
                $updated += $result
            }

            if($OldTenantTag){
                $result = Remove-ODTenantTag -StepAction $action -TenantTag $OldTenantTag
                $updated += $result
            }
            
       }    

    }

    if($updated -ge 1){
         $octo.DeploymentProcesses.Modify($deploymentProcess)
         Write-Output "TenantTag updated!"
    }
    else{
         Write-Output "No changes in TenantTag!"
    }

}
