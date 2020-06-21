function New-ODLibraryVariableSet($Name){

    Write-Host "Creating new LibraryVariableSet in octopus"
    $newLV = ""
    $newLibraryVariableSet = New-Object Octopus.Client.Model.LibraryVariableSetResource
    $newLibraryVariableSet.Name = $Name 
    $newLibraryVariableSet.Description = "This is $Name LibrarySet"
    $newLV = $octo.LibraryVariableSets.Create($newLibraryVariableSet)

    return $newLV
}