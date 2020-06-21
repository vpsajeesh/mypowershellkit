function Get-ODVariableList($variableSetId){

    $results = @()     
    $OctopusEnvList = $octo.Environments.GetAll()
    $varSets = Get-ODVariableSet -variableSetId $variableSetId
    
    foreach($vset in $varSets){
       
            $results += ConvertTo-ODVariableList -variableSetVars $($vset.Variables) -SetName $vset.Name
            
    }

    foreach($res in $results){

        switch($res.ScopeType){
            'Environment' {
                
                $res.ScopeValue = $OctopusEnvList | Where-Object { $_.Id -eq $res.ScopeValue } | Select-Object -ExpandProperty name # | ForEach-Object { $OctopusRepo.Environments.Get($_).Name}
                break;
                }         
        }

    }
    return $results
}