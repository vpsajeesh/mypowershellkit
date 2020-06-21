function Get-TCBuildConfigurationList($buildName=$null,$buildId=$null,$projectId=$null,$projectName=$null){
  
    $searchString = ""
    if($projectId){
      $searchString = "?locator=affectedProject:(id:$projectId)"
    }
    elseif($buildId){
      $searchString = "?locator=id:$buildId"
    }
        
    $buildprojectListURL = "$teamCityHost/app/rest/buildTypes/$searchString"
    $buildprojectListURLResponse = Invoke-TCWebRequest -URL $buildprojectListURL -Method Get
    $TeamCitybuildProjects = ([xml]$buildprojectListURLResponse.Content).buildtypes.buildtype

    if($BuildName){
        $TeamCitybuildProjects = $TeamCitybuildProjects | Where-Object { $_.Name -match "$BuildName" }
    }

    if($projectName){
        $TeamCitybuildProjects = $TeamCitybuildProjects | Where-Object { $_.ProjectName -match "$projectName" }
    }

    return $TeamCitybuildProjects

}
