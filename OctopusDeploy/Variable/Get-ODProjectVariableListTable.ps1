function Get-ODVariableListTable($variableSetId,$EnvList=$null){
    
    $results = @()  

    $varSets = Get-ODVariableSet -variableSetId $variableSetId
    
    foreach($vset in $varSets){
       $results += ConvertTo-ODVariableListTable -variableSetVars $vset.Variables -setName $vset.Name -EnvList $EnvList
    }        
    
    $results      
}

function Get-ODProjectVariableListTable($ProjectName,$EnvList=$null){
    $results = @() 
	$Proj = Get-ODProject -projectName $ProjectName
    $results = Get-ODVariableListTable -variableSetId $Proj.VariableSetId -EnvList $EnvList     
    
    return $results       
}

function Get-ODProjectVariableListTableAll($ProjectName,$EnvList=$null){
    
    $results = @()    
    $Proj = Get-ODProject -projectName $ProjectName
    $results = Get-ODProjectVariableListTable -ProjectName $ProjectName -EnvList $EnvList           
      
    $libSets = Get-ODLibrarySet -project $Proj
    
    foreach($libset in $libSets){ 
                   
             $libVariableSets = $octo.LibraryVariableSets.Get($libset)
             
             foreach($lSet in $libVariableSets){
                
                $results += Get-ODVariableListTable -variableSetId $lSet.VariableSetId -EnvList $EnvList                 

             }
    }    
    return $results       
}