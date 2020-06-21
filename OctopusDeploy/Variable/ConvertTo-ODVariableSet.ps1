function ConvertTo-ODVariableSet($VariableList,$PlaceHolderReplace=$null){
    
    $OctopusEnvList = Get-ODEnvironmentList
    $NewVariableSet = New-Object Octopus.Client.Model.VariableSetResource
    foreach($var in $VariableList){
    
        $variable = new-object Octopus.Client.Model.VariableResource
        $variable.Name = $var.Name
		if(-not ($PlaceHolderReplace)){       
			$variable.Value = $var.Value -replace "{PLACEHOLDER", "#{PLACEHOLDER"
		} 
		else{
			$variable.Value = $var.Value -replace "$PlaceHolderReplace", "#$($PlaceHolderReplace)"
		}
		
        $ScopeIds = @()

        foreach($scope in $var.Scope){

            $EnvironmentScope = $OctopusEnvList | Where-Object { $_.Name -eq $scope } | select Id
            if(!($EnvironmentScope)){
               Write-Host "Creating new Environment: $scope"
               $EnvironmentScope = New-ODEnvironment -Name $scope
            }
			
			if(($EnvironmentScope.Id)){
				Write-Host "Adding scope $($EnvironmentScope.id) to $($variable.Name)"
				$ScopeIds += $EnvironmentScope.Id 							   
            }
        }
        
        if($ScopeIds){
            $variable.Scope.Add([Octopus.Client.Model.ScopeField]::Environment, (New-Object Octopus.Client.Model.ScopeValue($ScopeIds)))    
        }
        $NewVariableSet.Variables.Add($variable)
    }
    return $NewVariableSet
}