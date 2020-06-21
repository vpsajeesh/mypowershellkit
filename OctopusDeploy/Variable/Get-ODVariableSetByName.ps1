function Get-ODVariableSetByName($LibrarySetName, $ProjectName){

    $VariableSet = ""

    If($LibrarySetName){
        Write-Host "LibrarySet mode ON" -ForegroundColor Yellow
        $libVarSet = Get-ODLibrarySetByName -LibrarySetName $LibrarySetName
        $VariableSet = Get-ODVariableSet -variableSetId $($libVarSet.VariableSetId)
    }
    else{    
        Write-Host "Project mode ON" -ForegroundColor Yellow
        $OctoProj = Get-ODProject -projectName $ProjectName

        if(!($OctoProj)){
            throw "No Project found!"
        }
        
        $VariableSet = Get-ODVariableSet -variableSetId $($OctoProj.VariableSetId)
		<#
        # project variable set is empty, it will search for library set using the second part of Project Name
        if(!($VariableSet.Variables)){
            $LibrarySetName = ($OctoProjName -split ' ')[1]
            $libVarSet = Get-ODLibrarySetByName -LibrarySetName $LibrarySetName -repository $octo
            $VariableSet = Get-ODVariableSet -repository $octo -variableSetName $($libVarSet.links.variables)
        }
		#>
    }
    return $VariableSet
}