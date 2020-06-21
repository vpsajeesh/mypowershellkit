function Get-TCUser($userID){
    $userUrl = "$teamCityHost/app/rest/users/id:$userID"
    $userURLresponse = Invoke-TCWebRequest -URL $userUrl -Method Get

    $User = ([xml]$userURLresponse.Content).user 
    
    return $User
}