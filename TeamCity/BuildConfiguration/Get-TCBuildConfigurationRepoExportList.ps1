function Get-TCBuildConfigurationRepoExportList(){

    $buildProjs = Get-TCBuildList 

    $BuildVcsList = @()
    $counter = 0
    foreach($bp in $buildProjs){

        $BuildProj = Get-TCBuildDetails -buildId $bp.Id
        $VcsIDs = $BuildProj.'vcs-root-entries'.'vcs-root-entry'.id

        foreach($id in $VcsIDs){

            $BuildProjObj = "" | Select BuildName,ProjectGroup,ProjectName,RepoURL,RepoProject,VcsId,VcsName,BuildProjURL,BuildId,Paused
            $VcsRoot = Get-TCVcsRoot -VcsRootId $id 
            $VcsURL = $VcsRoot.properties.property | Where-Object { $_.name -eq "tfs-url" } | select -ExpandProperty Value
            $VcsRootProject = $VcsRoot.properties.property | Where-Object { $_.name -eq "tfs-root" } | select -ExpandProperty Value
            $BuildProjObj.BuildId = $BuildProj.Id
            $BuildProjObj.BuildName = $BuildProj.Name
            $BuildProjObj.ProjectGroup = (($BuildProj.projectName -split "/")[0]).Trim()
            $BuildProjObj.ProjectName = $BuildProj.ProjectName
            $BuildProjObj.VcsId = $id
            $BuildProjObj.VcsName = $VcsRoot.Name
            $BuildProjObj.RepoURL = $VcsURL
            $BuildProjObj.RepoProject = $VcsRootProject
            $BuildProjObj.Paused = $BuildProj.paused
            $BuildProjObj.BuildProjURL = $BuildProj.webUrl
            $BuildVcsList += $BuildProjObj
        }

        $counter ++
        Write-Progress -Activity "Collecting Repository Details for all Build Projects" -Status "Done : $counter of $($buildProjs.Count)" -PercentComplete (($counter / $($buildProjs.Count)) * 100)

    }
    return $BuildVcsList
}
