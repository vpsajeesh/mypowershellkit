function Update-TCVcsRootURL($VcsRootId,$newVcsURL){

    $VcsRoot = Get-TCVcsRoot -VcsRootId $VcsRootId

    If($VcsRoot) {    
        $VcsRootURL = "$teamCityHost$($VcsRoot.href)/properties/tfs-url"
                
        try{
             $VcsRootURLResponse = Invoke-WebRequest -Uri $VcsRootURL -Method PUT -Headers $headers -ContentType "text/plain" -Body $newVcsURL
        }
        catch{
             Write-Warning "Failed to update VCS Root :  $($VcsRoot.Id)[$($VcsRoot.href)]"
        }
    }
    
    return $VcsRootURLResponse
}
