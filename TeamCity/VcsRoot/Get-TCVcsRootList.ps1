function Get-TCVcsRootList($ProjectId=$null,$ProjectName=$null){
    
    $project = ""
    if($ProjectId){
        $project = "project(id:$ProjectId),"
    }
    elseif($ProjectName){
        $project = "project(name:$ProjectName),"
    }
    
    $vcsrootlisturl = "$teamCityHost/app/rest/vcs-roots?locator=$($project)start:0,count:5000"
    $vcsrootlisturlresponse = Invoke-TCWebRequest -URL $vcsrootlisturl -Method Get

    $vcsrootList = ([xml]$vcsrootlisturlresponse.Content)."vcs-roots"."vcs-root"
    return $vcsrootList
}
