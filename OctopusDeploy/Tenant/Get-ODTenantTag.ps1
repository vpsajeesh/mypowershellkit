function Get-ODTenantTag($TenantTag){

    $TenantTag = $TenantTag -split "\\"
    if($TenantTag.Count -ne 2){
        throw "Please input TenantTag as TagSetName\TenantTagName"
    }

    
    $TagSet = $octo.TagSets.FindByName($TenantTag[0].Trim())

    if(!($TagSet)){
        throw "There is no Tenant Set with name $($TenantTag[0])"
    }

    $TenantTagVar = $TagSet.Tags | ? {$_.Name -eq $TenantTag[1] }

    if(!($TenantTagVar)){
        throw "There is no Tenant Tag $($TenantTag[1]) in PT-Deploy set"
    }

    return $TenantTagVar
}
