function Connect-TCWebApi($TCURL,$TCUserName,$TCPassword){
    $user = $TCUserName
    $password = $TCPassword
    $global:teamCityHost = ($TCURL).TrimEnd("/")
    $pair = "$($user):$($password)"

    $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
    $basicAuthValue = "Basic $encodedCreds"
    $global:headers = @{
        "Authorization" = $basicAuthValue;
        #"Accept" = "application/xml";
        #"Content-Type" = "application/xml";
    }

    try{
    $TCServerResponse = Invoke-TCWebRequest -URL "$teamCityHost/app/rest/server" -Method Get
    }
    catch{
       throw "Failed to connect TeamCity!"
    }
    If(([xml]$TCServerResponse.Content).Server){
            Write-Output "TeamCity Connection Established!"
    }
    

}
