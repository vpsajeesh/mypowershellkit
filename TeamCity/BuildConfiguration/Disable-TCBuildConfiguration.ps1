function Disable-TCBuildConfiguration($BuildId){

    $buildprojectURL = "$teamCityHost/app/rest/buildTypes/$buildId/deleted"
    $buildprojectURLResponse = Invoke-WebRequest -Uri $buildprojectURL -Method Put -Body "true" -ContentType "text/plain"
    $TeamCitybuildProjectStatus = $buildprojectURLResponse.Content
        
    return $TeamCitybuildProjectStatus

}
