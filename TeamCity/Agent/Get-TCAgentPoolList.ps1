function Get-TCAgentPoolList(){

    $agentpoollisturl = "$teamCityHost/app/rest/agentPools"
    $agentpoolresponse = Invoke-TCWebRequest -URL $agentpoollisturl -Method Get

    $agentpools = ([xml]$agentpoolresponse.Content).agentPools.agentPool
    return $AgentPools
}
