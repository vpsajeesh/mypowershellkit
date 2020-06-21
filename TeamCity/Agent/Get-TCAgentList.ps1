function Get-TCAgentList(){
        
    $agentAgentListUrl = "$teamCityHost/app/rest/agents"
    $agentresponse = Invoke-TCWebRequest -URL $agentAgentListUrl -Method Get

    $agents = ([xml]$agentresponse.Content).agents.agent 
    
    return $agents
}
