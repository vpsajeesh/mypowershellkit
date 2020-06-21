function Get-TCBuildConfiguration($buildId){
             
    $buildprojectListURL = "$teamCityHost/app/rest/buildTypes/id:$buildId"
    $buildprojectListURLResponse = Invoke-TCWebRequest -URL $buildprojectListURL -Method Get
    $TeamCitybuildProjects = ([xml]$buildprojectListURLResponse.Content).buildtype
        
    return $TeamCitybuildProjects

}
