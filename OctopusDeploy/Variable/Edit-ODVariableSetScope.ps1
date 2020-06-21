function Edit-ODVariableSetScope($EnvironmentName, $NewEnvironmentName, $VariableSetId){

    $VariableSet = $octo.VariableSets.Get($VariableSetId)

    $OldEnvId = ($octo.Environments.FindByName($EnvironmentName)).Id

    $NewEnvId = $octo.Environments.FindByName($NewEnvironmentName).Id

    $variables = $VariableSet.Variables | Where-Object { $_.Scope -match $OldEnvId }

    if(!($variables))
    {
        Write-Host "No Variables Found with Env : $EnvironmentName" -ForegroundColor Red
    }

    $rollback = $false
    foreach($var in $variables){
        Write-Host ""
        try {

            if($var.Scope["Environment"]){

                 Write-Host "PlaceHolder : $($var.Name)" -ForegroundColor Green
                 $var.Scope["Environment"] 

            
                if($var.Scope["Environment"] -notmatch $NewEnvId){
                    Write-Host "Environment $NewEnvId does not exist. Adding now - " -ForegroundColor Yellow -NoNewline
               
                    if($var.Scope["Environment"].Add($NewEnvId)){
                         Write-Host "Success" -ForegroundColor Green                    
                    }
                    else{
                        Write-Host "Failed" -ForegroundColor Red
                        $rollback = $true                
                    }
               
                 }
            
                 Write-Host "Removing Environment $OldEnvId - " -ForegroundColor Yellow -NoNewline
             
                 if($var.Scope["Environment"].Remove($OldEnvId)){
                    Write-Host "Success" -ForegroundColor Green                
                 }
                 else{
                    Write-Host "Failed" -ForegroundColor Red
                    $rollback = $true               
                 }  
             
                Write-Host ""
        
            }
        
        }
        catch{
            throw 
        }
    
    }

    if(!($rollback)){

        if ($octo.VariableSets.Modify($variableset)) {

                Write-Host "variabe successfully modified"
        }
   
    }
}

function Edit-ODProjectVariableSetScope($ProjectName, $EnvironmentName, $NewEnvironmentName){
    
    $Project = Get-ODProject -projectName $ProjectName
    
    Edit-ODVariableSetScope -EnvironmentName $EnvironmentName -NewEnvironmentName $NewEnvironmentName -VariableSetId $Project.VariableSetId
}

function Edit-ODLibraryVariableSetScope($LibrarySetName, $EnvironmentName, $NewEnvironmentName){
    
    $libVariableSet = $octo.LibraryVariableSets.FindByName($LibrarySetName) 
    

    Edit-ODVariableSetScope -EnvironmentName $EnvironmentName -NewEnvironmentName $NewEnvironmentName -VariableSetId $libVariableSet.VariableSetId
}
