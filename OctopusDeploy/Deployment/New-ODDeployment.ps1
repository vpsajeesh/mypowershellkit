function New-ODDeployment($ProjectName,$EnvironmentName,$ReleaseNumber,$TenantNames,$StepsToSkip){

    
    $environment = $octo.Environments.FindByName($EnvironmentName)

    if(-not $environment){
        throw "Environment Not Found!"
    }

    $project = Get-ODProject -ProjectName $ProjectName
       
    if($TenantNames){
        $TenantNames = $TenantNames -split ","

        $tenantsCollected = @()
        foreach($tname in $TenantNames){
            
            $tanant = $octo.Tenants.FindByName($tname) 

            if($tanant){
                $tenantsCollected += $tanant
            }
            else{
                throw "Tenant $tname Not Found!"
            }
        }
    }    

       

    $deploymentProcess = $octo.DeploymentProcesses.Get($project.DeploymentProcessId)
    
    $skipStep = $deploymentProcess.Steps.Actions | Where-Object { $_.Name -in $StepsToSkip }

    $release = $octo.Projects.GetReleaseByVersion($project,$ReleaseNumber)

    $deployment = new-object Octopus.Client.Model.DeploymentResource

    $deployment.ReleaseId = $release.Id
    $deployment.ProjectId = $release.ProjectId
    $deployment.ChannelId = $release.ChannelId
    $deployment.EnvironmentId = $environment.Id


    $AddedstepsToSkip = new-object Octopus.Client.Model.ReferenceCollection 
    $skipStep | ForEach-Object { $AddedstepsToSkip.Add($_.Id) }

    $deployment.SkipActions = $AddedstepsToSkip

    if($tenantsCollected){
        foreach($tenant in $tenantsCollected){
            $deployment.TenantId = $tenant.Id
            Invoke-ODDeployment -deploymentObject $deployment
        }
    }
    else{
        Invoke-ODDeployment -deploymentObject $deployment
    }
}

