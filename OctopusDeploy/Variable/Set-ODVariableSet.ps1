function Set-ODVariableSet($NewEnvPlaceHolders, $Variables, $Environment){

	$NewEnvironmentName = $Environment.Name
    foreach($plchldr in $NewEnvPlaceHolders){
        Write-Host "Working on PlaceHolder : $($plchldr.PlaceHolder)"
        $PlaceHoldervalueExists = $false
        $PlaceHolderExists = $false
        foreach($var in $Variables){

            if($var.Name -eq $plchldr.PlaceHolder ){                     
          
                    $PlaceHolderExists = $true
                    if($var.Value -eq $plchldr.$NewEnvironmentName){
                         $PlaceHoldervalueExists = $true 
                         Write-Host "Value already exists! Adding Scope Now" -ForegroundColor Green   
                      
                         if($var.Scope["Environment"].Add($Environment.Id)){
                              Write-Host "Adding Scope:Success" -ForegroundColor Green                    
                         }
                         else{
                              Write-Host "Adding Scope:Failed" -ForegroundColor Red
                              throw "Failed to add new environment scope"
                              $rollback = $true                
                         }                 
                    }      

            }
        }
		
        if($PlaceHolderExists){
            if(!($PlaceHoldervalueExists)){
                    Write-Host "Adding New Value for Scope $NewEnvironmentName" -ForegroundColor Magenta  

                    $variable = new-object Octopus.Client.Model.VariableResource
                    $variable.Name = $plchldr.PlaceHolder      
                    $variable.Value = $plchldr.$NewEnvironmentName
                    $variable.Scope.Add([Octopus.Client.Model.ScopeField]::Environment, (New-Object Octopus.Client.Model.ScopeValue($Environment.Id)))                   
                    $Variables.Add($variable)
                  
            } 
        }
        else{
			Write-Host "Placeholder Missing. Adding now." -BackgroundColor Yellow -ForegroundColor Black
			$variable = new-object Octopus.Client.Model.VariableResource
			$variable.Name = $plchldr.PlaceHolder      
			$variable.Value = $plchldr.$NewEnvironmentName
			$variable.Scope.Add([Octopus.Client.Model.ScopeField]::Environment, (New-Object Octopus.Client.Model.ScopeValue($Environment.Id)))                   
			$Variables.Add($variable)            
        }
     
    }

    return $Variables
}
