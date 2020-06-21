function Get-ODEnvironmentList(){

    return $octo.Environments.GetAll()
}

function Get-ODMachineList(){

    return $octo.Machines.GetAll()
}

function Get-ODProject($projectName){
    Write-Verbose "Doing Get-OctopusProject" 
    $project = $octo.Projects.FindByName($projectName)    

    If(-not $project){
        throw "Project Not Found!"
    }

    return  $project
}

function Get-ODVariableSet($variableSetId) {    

    Write-Verbose "Doing Get-OctopusVariableSet for $variableSetId"    
    $variableset = $octo.VariableSets.Get($variableSetId)
    return $variableset
}

function Get-ODLibrarySetByName($LibrarySetName){

    Write-Verbose "Doing Get-OctopusLibrarySetByName"  
    $libVarSet = $octo.LibraryVariableSets.FindByName($LibrarySetName)
    If(!$libVarSet){
        throw "Library Set not found"
    }
    
    return $libVarSet
}

function Get-ODLibrarySet($project){
    Write-Verbose "Doing Get-OctopusLibrarySet"   
    $librarySets = $project.IncludedLibraryVariableSetIds

    if(!$librarySets){
        throw "LibrarySet not found!"
    }
    return $librarySets
}
