function Get-ODProjectVariableList($ProjectName){

	$projDetails = Get-ODProject -projectName $ProjectName
	If(!($projDetails)){
        throw "Project $projectName Not Found in octopus"
    }
	
    $results = Get-ODVariableList -variableSetId $($projDetails.VariableSetId)
    return $results
}

function Get-ODProjectVariableListFull($ProjectName){  
    
    $projDetails = Get-ODProject -projectName $ProjectName
    If(!($projDetails)){
        throw "Project $projectName Not Found in octopus"
    }
   
    $results += Get-ODVariableList -variableSetId $($projDetails.VariableSetId)
           
    $libSets = Get-ODLibrarySet -project $projDetails
    
    foreach($libset in $libSets){ 
                   
             $libVariableSets = $octo.LibraryVariableSets.Get($libset)
             
             foreach($lSet in $libVariableSets){
             
                $results += Get-ODVariableList -variableSetId $($lSet.VariableSetId)             

             }
    }
    
    return $results   
    
}