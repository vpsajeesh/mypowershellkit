function Get-TCBuildConfigurationStep($BuildId,$StepId){

    $buildStepURL = "$teamCityHost/app/rest/buildTypes/$BuildId/steps/$StepId"
    try{
       $buildStepURLResponse = Invoke-TCWebRequest -URL $buildStepURL -Method Get
    }
    catch{
        throw "Unable to find Build step!"
    }
    $buildStep = ([xml]$buildStepURLResponse.Content).Step
        
    return $buildStep
}
