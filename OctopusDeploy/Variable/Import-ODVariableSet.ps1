function Import-ODLibraryVariableWithScopeFromCSV($LibrarySetName,$EnvironmentName,$CSVFile,$RunUpdate){    

    if(-not (Test-Path "$CSVFile")){
        throw "CSV File not found!"
    }

    $NewEnvPlaceHolders = Import-Csv $CSVFile

    Add-ODVariableScope -EnvironmentName $EnvironmentName -LibrarySetName $LibrarySetName -NewEnvPlaceHolders $NewEnvPlaceHolders -RunUpdate $RunUpdate
    Write-Host "Please check C:\temp\before.txt and C:\temp\After.txt Files for changes!"
}

function Import-ODProjectVariableWithScopeFromCSV($ProjectName,$EnvironmentName,$CSVFile,$RunUpdate){

    if(-not (Test-Path "$CSVFile")){
        throw "CSV File not found!"
    }

    $NewEnvPlaceHolders = Import-Csv $CSVFile

    Add-ODVariableScope -EnvironmentName $EnvironmentName -ProjectName $ProjectName -NewEnvPlaceHolders $NewEnvPlaceHolders -RunUpdate $RunUpdate
    Write-Host "Please check C:\temp\before.txt and C:\temp\After.txt Files for changes!"
}