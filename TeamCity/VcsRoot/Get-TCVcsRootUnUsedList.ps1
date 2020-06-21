function Get-TCVcsRootUnUsedList(){
    $VcsRoots = Get-TCVcsRootList
    $totalItem = $VcsRoots.Count
    $counter = 0
    $notInUseVcsRoots = @()
    foreach($vcs in $VcsRoots){
    
        $vcsRoot = Get-TCVcsRoot -VcsRootId $vcs.Id
        
        $result = Get-TCSVcsRootInstances -VcsRoot $vcsRoot

        if(-not $result){        
           Write-Information "Vcs Root : $($vcs.Name) from $($vcsRoot.project.parentProjectId)\$($vcsRoot.project.Name) : $($VcsRoot.webURL)"   
           $notInUseVcsRoots += $vcsRoot
           #Remove-TCVcsRoot -VcsRootId $vcs.id
           #Write-Output "Deleted VCS Root!"
        }
    
        $counter++
        Write-Progress -Activity "Clean-up VCS Root details" -Status "Performed: $counter of $totalItem" -PercentComplete (($counter / $totalItem)*100)

    }

    $notInUseVcsRoots
}