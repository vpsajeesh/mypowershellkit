function Update-ODVariableSet($VariableSetId,$NewVariableSet){

    $VariableSet = $octo.VariableSets.Get($VariableSetId)
    $VariableSet.Variables = $NewVariableSet.Variables

    try{
        $VUpdated = $octo.VariableSets.Modify($VariableSet)
    }
    catch{
        throw "Error"
    }
    return $VUpdated
}

function Update-ODLibraryVariableSet($LibrarySetName,$NewVariableSet){

    if(!($octo.LibraryVariableSets.FindByName($LibrarySetName))){
        
        $NewLV = New-ODLibraryVariableSet -Name $LibrarySetName -OctopusRepo $OctopusRepo
    }

    $LVCreated = $octo.LibraryVariableSets.FindByName($LibrarySetName)
    
    Update-ODVariableSet -VariableSetId $LVCreated.VariableSetId -NewVariableSet $NewVariableSet  -OctopusRepo $OctopusRepo
}
