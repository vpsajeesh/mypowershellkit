function Get-TCVcsRootInstances($VcsRoot){    
    
    $VcsInstancesURL = "$teamCityHost$($VcsRoot.vcsRootInstances.href)"
    $VcsInstancesURLResponse = Invoke-TCWebRequest -URL $VcsInstancesURL -Method Get
    $VcsInstances = ([xml]$VcsInstancesURLResponse.Content)."vcs-root-instances"."vcs-root-instance"
    return $VcsInstances
}
