<#
This will help to create release for both child and Master Project.
It uses PackageToDeploy for Child project scenaria
It uses ProcessToDeploy for Master Project scenaria
After disabling the steps, It will create Release.
Rollback will be performed on Projects after creating Release.
#>


function Select-ODReleasePackageVersion($Release, $PackageToDeployListWithVersion, $TemplatePackage){
    
    $package = $TemplatePackage
    $feed = $octo.Feeds.Get($package.FeedId)
    
    $selectedPackage = new-object Octopus.Client.Model.SelectedPackage   
    $PackageWithVersion = $PackageToDeployListWithVersion | Where-Object { $_ -match "$($package.PackageId):" }

    if($PackageWithVersion){
        $packageVersion = (($PackageWithVersion -split ":")[1]).Trim()

        if(-not $packageVersion){
            $packageVersion = $octo.Feeds.GetVersions($feed, "$($package.PackageId)") | Select-Object -ExpandProperty Version
        }
    }
    else{
        $packageVersion = $octo.Feeds.GetVersions($feed, "$($package.PackageId)") | Select-Object -ExpandProperty Version
    }

    $selectedPackage.Version = $packageVersion 
    $selectedPackage.ActionName = $package.ActionName
    $release.SelectedPackages.Add($selectedPackage)
}

function New-ODRelease($ProjectName, $ChannelName, $RelaseName, $PackagesToDeploy, $StepToDeploy){

    $Project = Get-ODProject -projectName $ProjectName
    $channel = $octo.Channels.FindByName($Project,$ChannelName)

    if(-not $channel){
        throw "Channel Not Found"
    }

    $deploymentProcessbkup = $octo.DeploymentProcesses.Get($Project.DeploymentProcessId) 
    $deploymentProcess = $octo.DeploymentProcesses.Get($project.DeploymentProcessId) 

    $PackageToDeployListWithVersion = $PackagesToDeploy -split "," 
    $PackageToDeployList = $PackageToDeployListWithVersion | ForEach-Object { ($_ -split ":")[0] }

    If($StepToDeploy -or $PackageToDeployList){
        foreach($dpStep in $deploymentProcess.Steps){ 
            
            foreach($action in $dpStep.Actions){

                $packageName = $action.Properties["Octopus.Action.Package.PackageId"].Value

                if(-not ((($packageName -in $PackageToDeployList) -and $PackageToDeployList) -or (($action.Name -in $StepToDeploy) -and $StepToDeploy))){
                    $action.IsDisabled = $true
                }
            }
        }
    }

    $octo.DeploymentProcesses.Modify($deploymentProcess)

    try{
        $template = $octo.DeploymentProcesses.GetTemplate($deploymentProcess,$channel)

        $release = new-object Octopus.Client.Model.ReleaseResource

        if($RelaseName){
            $release.Version = $RelaseName
        }
        else{
            $release.Version = $template.NextVersionIncrement
        }

        $release.ProjectId = $project.Id
        $release.ChannelId = $channel.Id        

        foreach ($package in $template.Packages)
        {        
            Select-ODReleasePackageVersion -Release $release -PackageToDeployListWithVersion $PackageToDeployListWithVersion -TemplatePackage $package    
        }

        $response = $octo.Releases.Create($release, $false) 
    
    }
    catch{

        if( $_ -match "Unable to process response from server: Unexpected character encountered while parsing value:"){
            Write-Host "Release has been created now!"
         }
         else{
            Wrtie-Host $_
         }
    }
    finally {
       

        ##############################RESET PROJECT###################################

        $deploymentProcessRevert = $octo.DeploymentProcesses.Get($project.DeploymentProcessId) 
        $deploymentProcessRevert.Steps.Clear()
        $deploymentProcessRevert.Steps.AddRange($deploymentProcessbkup.Steps)
        $deploymentProcessbk.Actions
        $octo.DeploymentProcesses.Modify($deploymentProcessRevert)

    }        

}
