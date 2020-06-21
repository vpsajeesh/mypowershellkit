function Remove-TCBuildConfigurationStep($BuildId,$StepId){
    
    $buildStep = Get-TCBuildConfigurationStep -BuildId $BuildId -StepId $StepId

    If($buildStep) {    
        $buildStepURL = "$teamCityHost/app/rest/buildTypes/$BuildId/steps/$StepId"
        
        $buildStepURLResponse = Invoke-TCWebRequest -URL $buildStepURL -Method DELETE
    }
    
    return $buildStepURLResponse
}
