function New-VariableObject($EnvList){
    
	If(-not ($EnvList)){
		throw "No Environment List Found!"
	}
	
    $CusObject = New-Object -TypeName psobject 
    $CusObject | Add-Member -MemberType NoteProperty -Name "PlaceHolder" -Value "" | Out-Null

    if($EnvList){
        foreach($env in $EnvList){
        
            $CusObject | Add-Member -MemberType NoteProperty -Name "$env" -Value "" | Out-Null
        
        }
    }
    else{
        $CusObject | Add-Member -MemberType NoteProperty -Name "Value" -Value "" | Out-Null
    }
    return $CusObject
}

function Get-ODVariableSetEnvironmentList($VariableSetVars){	

	Write-Verbose "Doing Get-ODVariableSetEnvironmentList"
	
	$EnvironmentList = @()
	$EnvironmentIdList = $VariableSetVars | foreach-Object {  $_.Scope["Environment"] } | select -Unique
	$EnvironmentIdList | foreach-Object {$EnvironmentList += $octo.Environments.Get($_)}
	
	Write-Verbose "Done Get-ODVariableSetEnvironmentList"
	return $EnvironmentList
}

function ConvertTo-ODVariableListTable($variableSetVars,$setName,$OctoRepo, $EnvList=$null){
    Write-Verbose "Doing ConvertTo-ODVariableListTable"
    
    $variables = @()
    $OctoEnvList = Get-ODEnvironmentList
	
	if(-not ($EnvList)){
		$EnvironmentList = Get-ODVariableSetEnvironmentList -VariableSetVars $variableSetVars
		If($EnvironmentList){
			$EnvList = $EnvironmentList | Select-Object -ExpandProperty Name
		}
	}
	$counter = 0
	$UniqueVars = $variableSetVars | Group-Object Name
    foreach($var in $UniqueVars){
       $variable = New-VariableObject -EnvList $EnvList      
       $variable."PlaceHolder" = $var.Name

       foreach($v in $var.Group){   
        
           if($v.Scope.Count -gt 0){   
            
              if($v.Scope.Keys){

                 foreach($scope in $v.Scope.Keys){

                     if($scope -eq "Environment") {

                        $svalues = $v.Scope[$scope] -replace ' '
                
                        if($svalues){
                             foreach($sval in $svalues){
                                $envName = $OctoEnvList | Where-Object { $_.Id -eq $sval } | Select-Object -ExpandProperty Name
                                #$envNameTrimmed = $envName -replace ' '
                                if($EnvList -contains $envName){
                                      
                                        $variable.$envName = $v.Value
                                } 
                             }

                        }

                     }
                 }                
              }
            
           }
           else{
               foreach($envName in $EnvList){                                      
                        $variable.$envName = $v.Value
                } 

           }          

       }  
	   
       $variables += $variable	 
	   $counter++	   
	   Write-Progress -Activity "Converting VariableSet Entries to List Object" -Status "Done : $counter of $($UniqueVars.Count)" -PercentComplete (($counter / $($UniqueVars.Count) * 100))
    }
	Write-Verbose "Done ConvertTo-ODVariableListTable"
    return $variables
}