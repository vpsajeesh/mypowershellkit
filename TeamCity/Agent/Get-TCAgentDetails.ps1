function Get-TCAgentDetails($AgentId=$null, $AgentName=$null){
   
    $agents = Get-TCAgentList 
    
    if($AgentId){
        $agents = $agents | Where-Object { $_.Id -eq $AgentId }

    }elseif($AgentName)
    {
        $agents = $agents | Where-Object { $_.Name -eq $AgentName }
    }
    else{
        Write-Output "Please specify the Agent Id or Name"
    }
    
    $agentDtlsUrl = "$teamCityHost/app/rest/agents/id:$($agents.Id)"

    try{
         $TCAgentDetailsResponse = Invoke-TCWebRequest -URL $agentDtlsUrl -Method Get
    }
    catch{
        throw "Unable to find the build project!"
    }
    $TCAgentDetails = ([xml]$TCAgentDetailsResponse.Content).agent
    return $TCAgentDetails

}
