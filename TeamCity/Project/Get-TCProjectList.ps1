function Get-TCProjectList(){
    $projectListURL = "$teamCityHost/app/rest/projects"
    $projectListURLResponse = Invoke-TCWebRequest -URL $projectListURL -Method Get
    $TeamCityProjects = ([xml]$projectListURLResponse.Content).Projects.project
    return $TeamCityProjects
}
