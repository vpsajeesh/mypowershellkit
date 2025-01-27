function Get-TCVcsRoot($VcsRootId=$null, $VcsRootName=$null){
    
    if($VcsRootId){
        
        $searchObject = "id:$VcsRootId"
    }
    elseif($VcsRootName){

        $searchObject = "name:$VcsRootName"
    }
    else {
        throw "Input missing: please provide vcs root id or name!"
    }

    
    $vcsrooturl = "$teamCityHost/app/rest/vcs-roots/$searchObject"

    try{
        $vcsrooturlresponse = Invoke-TCWebRequest -URL $vcsrooturl -Method Get
    }
    catch{
        throw "Error Happened! Please verify the vcs root id or name!"
    }

    $vcsroot = ([xml]$vcsrooturlresponse.Content)."vcs-root"
    return $vcsroot

}
