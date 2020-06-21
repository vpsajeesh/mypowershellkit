function Copy-ODDeploymentProcessStep($ProjectName, $DestinationProjectName, $StepName, $NewStepName="") {

    $project = Get-ODProject -ProjectName $ProjectName 

    if(!($project)){
        throw "There is no project with name $ProjectName"
    }

    $destProject = Get-ODProject -ProjectName $DestinationProjectName

    if(!($destProject)){
        throw "There is no project with name $DestinationProjectName"
    }

    $deploymentProcess = $octo.DeploymentProcesses.Get($project.DeploymentProcessId)
    $step = $deploymentProcess.Steps | Where-Object { $_.Name -eq $stepName }

    if(-not $step){
        throw "Step is missing!"
    }

    Write-Output "Found the step. Trying to clone the step" 

    if($NewStepName){

        $tempStep = New-Object Octopus.Client.Model.DeploymentStepResource
        $step.Id = $tempStep.Id
        $step.Name = $NewStepName
        if($step.Actions.Count -eq 1){
            $step.Actions[0].Name = $NewStepName
            $step.Actions[0].Id = $tempStep.Actions[0].Id
        }
        else{
            throw "Unable to copy the step as there are multiple actions in that step!"
        }
        Write-Output "Step will be created with name - $NewStepName"
    }

    
    $destDeploymentProcess = $octo.DeploymentProcesses.Get($destProject.DeploymentProcessId)
    $destDeploymentProcess.Steps.Add($step)
    $octo.DeploymentProcesses.Modify($destDeploymentProcess)
    Write-Output "Done Successfully!"

}