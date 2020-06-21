function ConvertTo-ODVariableList($VariableSetVars,$setName){
    Write-Verbose "Doing Get-OctopusVariable"
    
    $variables = @()
    foreach($var in $VariableSetVars){
              
        if($var.Scope.Keys){
            foreach($scope in $var.Scope.Keys){

                $svalues = $var.Scope[$scope] -replace ' '
                
                if($svalues){
                    foreach($sval in $svalues){
                        $variable = "" | select Name,Value,ScopeType,ScopeValue,SetName
                        $variable.Name = $var.Name
                        $variable.Value = $var.Value
                        $variable.ScopeType = $scope
                        $variable.ScopeValue = $sval 
                        $variable.SetName = $setName
                        $variables += $variable
                    }
                }
                else{
                        $variable = "" | select Name,Value,ScopeType,ScopeValue,SetName
                        $variable.Name = $var.Name
                        $variable.Value = $var.Value
                        $variable.ScopeType = $scope
                        $variable.ScopeValue = "" 
                        $variable.SetName = $setName
                        $variables += $variable

                }
            }
        }
        else{

            $variable = "" | select Name,Value,ScopeType,ScopeValue,SetName
            $variable.Name = $var.Name
            $variable.Value = $var.Value
            $variable.ScopeType = ""
            $variable.ScopeValue = ""
            $variable.SetName = $setName
            $variables += $variable
        }
    }

    return $variables
}