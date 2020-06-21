function Disable-TCBuildConfigurationStep($BuildId,$StepId){

    $buildStep = Get-TCBuildConfigurationStep -BuildId $BuildId -StepId $StepId

    If($buildStep) {    
        $buildStepURL = "$teamCityHost/app/rest/buildTypes/$BuildId/steps/$StepId/disabled"
        
        $buildStepURLResponse = Invoke-WebRequest -Uri $buildStepURL -Headers $headers -Method Put -Body "true" -ContentType "text/plain"
    }
    
    return $buildStepURLResponse.Content

}
