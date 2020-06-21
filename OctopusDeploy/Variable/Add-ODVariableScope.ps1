function Add-ODVariableScope($EnvironmentName, $LibrarySetName, $ProjectName, $NewEnvPlaceHolders, $RunUpdate){
  
    $octoEnv = $octo.Environments.FindByName($EnvironmentName)

    if(!($octoEnv)){
        throw "No Enviroment Found in Octopus"
    }
    
    $VariableSet = Get-ODVariableSetByName -LibrarySetName $LibrarySetName -ProjectName $ProjectName 

    if(!($VariableSet.Variables)){
        throw "Variable set not found!"
    }

    $Variables = $VariableSet.Variables
    $Variables | Out-File C:\temp\before.txt
    #First, remove the New Env from existing Variable set

    $rollback = $false

    $ExistingScopeValues = $Variables | Where-Object { $_.Scope -match $octoEnv.Id }

    if($ExistingScopeValues){
     
        Write-Host "Removing Scope"
       
        foreach($var in $ExistingScopeValues){
             if($var.Scope["Environment"].Remove($octoEnv.Id)){
                    Write-Host "Removing Scope: Success" -ForegroundColor Green                
             }
             else{
                    $rollback = $true 
                    Write-Host "Removing Scope: Failed" -ForegroundColor Red
                    throw "Failed To remove scope for $($var.Name) : $($_var.Value)"             
             } 

         }        
    }

    $Variables = Set-ODVariableSet -NewEnvPlaceHolders $NewEnvPlaceHolders -Variables $Variables -Environment $octoEnv
    
    $EmpyVariables = @()
    $EmpyVariables += $Variables | Where-Object { ($_.Value).Length -eq 0 } | ? { foreach($k in $_.Scope.Keys) {"$($_.Scope["$k"])" -eq "" }} | Select-Object Id
    $EmpyVariables += $Variables | Where-Object { ($_.Value).Length -eq 0 -and $_.Scope.Keys.Count -eq 0 }| Select-Object Id

    $VariableSetModified = New-Object Octopus.Client.Model.VariableSetResource
    $Variables | Where-Object { $_.id -notin $EmpyVariables.Id } | % { $VariableSetModified.Variables.Add($_) }
   
    #$VariableSet = $VariableSet.Variables | Where-Object { ($_.Value).Length -ge 0 } | ? { $_.Scope["$($_.Scope.Keys)"] -ne "" } 
    
    $VariableSetModified.Variables | Out-File C:\temp\After.txt -Force
    $VariableSet.Variables = $VariableSetModified.Variables
    if($RunUpdate){
        if(!($rollback)){

            if ($octo.VariableSets.Modify($VariableSet)) {

                    Write-Host "variabe successfully modified" -ForegroundColor Yellow
            }
   
        }
    }
}