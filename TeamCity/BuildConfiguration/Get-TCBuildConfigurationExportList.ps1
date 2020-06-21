function Get-TCBuildConfigurationExportList(){
    $buildprojs = Get-TCBuildConfigurationList

    $TCBuildExportList =@()
    $counter = 0
    $totalItem = $buildprojs.Count

    foreach($bp in $buildprojs){
   
       $buildprojitem = "" | select BuildName,RootProject,ProjectName,LastestBuildDate,BuildStatus,Paused,WebURL,BuildId
       $buildprojitem.BuildName = $bp.name
       $buildprojitem.ProjectName = $bp.projectName
       $buildprojitem.WebURL = $bp.WebURL
       $buildprojitem.RootProject = (($bp.projectName -split "/")[0]).Trim()
       $buildprojitem.BuildId = $bp.id
       $buildprojitem.Paused = $bp.Paused
       $latestBuild = Get-TCBuildConfigurationBuilds -buildProjectId $bp.Id -Latest
       if($latestBuild){
            $buildprojitem.LastestBuildDate = $latestBuild.finishDate
            $buildprojitem.BuildStatus = $latestBuild.status
       }
       $TCBuildExportList += $buildprojitem
       $counter ++
       Write-Progress -Activity "Collecting Build details" -Status "Collected: $counter of $totalItem" -PercentComplete (($counter/$totalItem)*100)
   
    }

    return $TCBuildExportList
}
