$ErrorActionPreference = 'Stop'

#Set-StrictMode -Version "Latest"
$functionsToLoad = Get-ChildItem "$($PSScriptRoot)\*" -Recurse -Include '*.ps1' -Exclude @('_*.ps1','*.Tests.ps1')

Write-Verbose "Function scripts to dot-source:"
$($functionsToLoad | Out-String)

foreach($functionScript in $functionsToLoad){

    . $functionScript
}

Export-ModuleMember -Function *-*

