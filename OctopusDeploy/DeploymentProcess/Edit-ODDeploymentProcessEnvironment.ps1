function Edit-ODDeploymentProcessEnvironment($ProjectName,$EnvironmentToRemove,$NewEnvironment, $StepNames){  
    
    $OldEnv = $octo.Environments.FindByName($EnvironmentToRemove)
    $NewEnv = $octo.Environments.FindByName($NewEnvironment)

    $StepNameList = $StepNames -split ","

    if(-not ($OldEnv -or $NewEnv)){
        throw "Environment Not Found!"
    }

    $project = Get-ODProject -ProjectName $ProjectName

    if(!($project)){
        throw "There is no project with name $ProjectName"
    }

    $deploymentProcess = $octo.DeploymentProcesses.Get($project.DeploymentProcessId)
    $updated = 0
    foreach ($step in $deploymentProcess.Steps)
    {
        foreach($action in  $step.Actions | Where-Object { ($_.Name -in $StepNameList -and $StepNameList) -or (-not $StepNameList)} ){
          
			if($OldEnv){
				If($action.Environments -contains $OldEnv.Id){   
                    
                    try{
						 $action.Environments.Remove($OldEnv.Id)
                         $action.Environments.Add($NewEnv.Id)
                         Write-Output "Removed Environment $($OldEnv.Name)"
                         $updated += 1
                     }
                     catch{
                        throw "Error happened while replacing!"
                        $updated = 0
                     }

				}
			}
			
			if($NewEnv){
				If($action.Environments -notcontains $NewEnv.Id){   
                    
                    try{
                         $action.Environments.Add($NewEnv.Id)
                         Write-Output "Added Environment $($NewEnv.Name)"
                         $updated += 1
                     }
                     catch{
                        throw "Error happened while replacing!"
                        $updated = 0
                     }

				}
			}
        }          
    }

    if($updated -gt 0){
        $octo.DeploymentProcesses.Modify($deploymentProcess)
    }   
}