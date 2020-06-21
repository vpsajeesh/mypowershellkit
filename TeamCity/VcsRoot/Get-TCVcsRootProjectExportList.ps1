function Get-TCVcsRootProjectExportList(){

    $VcsRoots = Get-TCVcsRootList
    $VcsURLList = @()
    $counter = 0
    foreach($vcs in $VcsRoots){
        $VcsURLObj = "" | select VcsId,Name,RepoURL,RepoProject,BuildProjectId,BuildProjectName,BuildParentProject
        $vcsDtls = Get-TCVcsRoot -VcsRootId $vcs.id
        $VcsURL = $vcsDtls.properties.property | Where-Object { $_.name -eq "tfs-url" } | select -ExpandProperty Value
        $VcsRootProject = $vcsDtls.properties.property | Where-Object { $_.name -eq "tfs-root" } | select -ExpandProperty Value
        $VcsURLObj.VcsId = $vcs.Id
        $VcsURLObj.Name = $vcs.name
        $VcsURLObj.RepoURL = $VcsURL
        $VcsURLObj.RepoProject = $VcsRootProject
        $VcsURLObj.BuildProjectId = $vcsDtls.Project.id
        $VcsURLObj.BuildProjectName = $vcsDtls.Project.name
        $VcsURLObj.BuildParentProject = $vcsDtls.Project.parentProjectId
        $VcsURLList += $VcsURLObj
        $counter ++
        Write-Progress -Activity "Collecting Repository Details for all VCS Roots" -Status "Done : $counter of $($VcsRoots.Count)" -PercentComplete (($counter / $($VcsRoots.Count)) * 100)
    }
    return $VcsURLList
}
