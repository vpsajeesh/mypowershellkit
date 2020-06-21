function Remove-TCBuildConfiguration($BuildId){

    $buildprojectURL = "$teamCityHost/app/rest/buildTypes/$buildId/"
    $buildprojectURLResponse = Invoke-TCWebRequest -URL $buildprojectURL -Method DELETE 
    
    return $buildprojectURLResponse

}
