function Remove-TCVcsRoot($VcsRootId){

    $VcsRoot = Get-TCVcsRoot -VcsRootId $VcsRootId

    If($VcsRoot) {    
        $VcsRootURL = "$teamCityHost$($VcsRoot.href)"
        
        try{
             $VcsRootURLResponse = Invoke-TCWebRequest -URL $VcsRootURL -Method DELETE
        }
        catch{
             Write-Warning "Failed to delete VCS Root :  $($VcsRoot.Id)[$($VcsRoot.href)]"

             "Failed to delete VCS Root :  $($VcsRoot.Id)[$($VcsRoot.href)]" | Out-File -FilePath "\\usmdcvfs004.us.kworld.kpmg.com\profiles\spurakkal\Appsense\My Docs\TeamCity\deleteFailurelog.txt" -Append 
        }
    }
    
    return $VcsRootURLResponse
}
