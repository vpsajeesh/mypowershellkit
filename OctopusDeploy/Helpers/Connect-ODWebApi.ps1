function Connect-ODWebApi($OctopusURL,$OctopusAPIKey) {

    
    $ScriptPath = split-path $SCRIPT:MyInvocation.MyCommand.Path -parent
	
	if(!($OctoDLLPath)){
		$OctoDLLPath = Join-Path "$ScriptPath\OctopusDeploy\Helpers" "tools"
	}
    
	$octopusDLL = Join-Path $OctoDLLPath "Octopus.Client.dll"
	
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
	
    Add-Type -Path "$octopusDLL"
    $OctopusSiteUrl = $OctopusURL
    $UserApiKey = $OctopusAPIKey
    try{
		$endpoint = New-Object Octopus.Client.OctopusServerEndpoint $OctopusSiteUrl,$UserApiKey
		$global:octo = New-Object Octopus.Client.OctopusRepository $endpoint
		Write-Host "Connected to Octopus Deploy Api!"
	}
	catch{
		throw "Failed to connect to Octopus Deploy Api!"
	}

}