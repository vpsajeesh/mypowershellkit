function Invoke-TCWebRequest($URL,$Method){
    
    $ProgressPreference = "SilentlyContinue"
    $result = Invoke-WebRequest -Uri $URL -Headers $headers -Method $Method
    $ProgressPreference = "Continue"
    return $result
}
