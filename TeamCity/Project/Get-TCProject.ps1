function Get-TCProject($Id){
    $projectURL = "$teamCityHost/app/rest/projects/id:$Id"
    $projectURLResponse = Invoke-TCWebRequest -URL $projectURL -Method Get
    $TeamCityProject = ([xml]$projectURLResponse.Content).Project
    return $TeamCityProject
}
