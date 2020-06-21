function Get-TCBuildConfigurationBuilds(){
    Param(
        [Parameter(Mandatory=$true)]
        [String] $buildProjectId,
        [Parameter(Mandatory=$false)] 
        [switch] $Latest,
        [Parameter(Mandatory=$false)]
        [ValidateSet("SUCCESS", "FAILURE", "UNKNOWN", "ALL")]
        [String] $Status = "ALL",
        [Parameter(Mandatory=$false)]
        [ValidateSet("true", "false", "any")]
        [String] $Pinned = "any"
    )

    $StatusValue = ""
    if($Status -ne "ALL"){
       $StatusValue = "status:$Status,"       
    }


    $LatestValue = ""
    if($Latest){
        $LatestValue = "count:1,"
    }

    $PinnedValue = "pinned:$Pinned"

    $buildURL = "$teamCityHost/app/rest/builds/?locator=buildType:$buildProjectId,$($StatusValue)$($LatestValue)$PinnedValue"
    
    $buildURLResponse = Invoke-TCWebRequest -URL $buildURL -Method Get
    $builds = ([xml]$buildURLResponse.Content).builds.build

    $BuildResults = @()
    foreach($build in $builds){
        $buildDtlURL = "$teamCityHost/app/rest/builds/id:$($build.Id)"
        $buildDtlURLResponse = Invoke-TCWebRequest -URL $buildDtlURL -Method Get
        $buildResult = ([xml]$buildDtlURLResponse.Content).build
        $BuildResults += $buildResult
    }

    return $BuildResults
}
