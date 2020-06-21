function Copy-ODLibraryVariableSet($LibrarySetName,$NewLibrarySetName){

    $libVariableSet = $octo.LibraryVariableSets.FindByName($LibrarySetName) 

    if(!$libVariableSet){
        throw "LibrarySet $LibrarySetName not found"
    }

    $varSetToCopy = $octo.VariableSets.Get($libVariableSet.VariableSetId)

    Update-ODLibraryVariableSet -LibrarySetName $NewLibrarySetName -NewVariableSet $varSetToCopy
}

<#
function Copy-ODLibraryVariableSetWithoutScope($LibrarySetName,$NewLibrarySetName){

    $libVariableSet = $octo.LibraryVariableSets.FindByName($LibrarySetName) 

    if(!$libVariableSet){
        throw "LibrarySet $LibSetName not found"
    }

    $VariableListWithHeader = Get-ODVariableListTable -variableSetId $libVariableSet.VariableSetId            

    if(-not $VariableListWithHeader ){

        throw "Unable to Load VariableList"
    }

    $variableList = Import-Csv "$OutputLocation\$($LibSetName).csv" -Header Name,Value | Select-Object Name,Value -Skip 1

    $octoVariableSet = ConvertTo-OctopusVariableSet -VariableList $variableList -OctopusRepo $octo

    Update-ODLibraryVariableSet -LibrarySetName $NewLibSetName -NewVariableSet $octoVariableSet  -OctopusRepo $octo
}

#>