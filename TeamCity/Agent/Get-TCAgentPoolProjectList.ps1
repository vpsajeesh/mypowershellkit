function Get-TCAgentPoolProjectList($AgentPoolId,$AgentPoolName){
   
   $agentPool = Get-TCAgentPoolList 
   if($AgentPoolId){
        $agentPool = $agentPool | Where-Object { $_.Id -eq $AgentPoolId }
   }
   elseif($AgentPoolName){
        $agentPool = $agentPool | Where-Object { $_.Name -eq $AgentPoolName }
   }
   else{
        throw "Please specify AgentPool Id or Name!"
   }

   $agentpoolDetailsUrl = "$teamCityHost/app/rest/agentPools/id:$($agentPool.Id)"
   $agentPoolDResponse = Invoke-TCWebRequest -URL $agentpoolDetailsUrl -Method Get
   $Projects = ([xml]$agentPoolDResponse.Content).agentPool.projects.project

   $TCAgentPoolProjectList = @()
   foreach($project in $Projects){
          
        $newProj = "" | select Id,Name,parentProjectId,archived,weburl,AgentPool
        $newProj.Id = $project.Id
        $newProj.Name = $project.name
        $newProj.parentProjectId = $project.parentProjectId
        $newProj.archived = $project.archived
        $newProj.weburl = $project.weburl
        $newProj.AgentPool = $agentpool.Name
        $agentpool.Name
        $TCAgentPoolProjectList += $newProj
        
    }

   return $TCAgentPoolProjectList
}
