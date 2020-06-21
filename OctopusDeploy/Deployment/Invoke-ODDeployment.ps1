function Invoke-ODDeployment($deploymentObject){
    try{
        Write-host "Deploying Release $($deploymentObject.ReleaseId)"
        $octo.Deployments.Create($deploymentObject)
    }
    catch{
         if( $_ -match "Unable to process response from server: Unexpected character encountered while parsing value:"){
            Write-Host "Deployment is running now!"
         }
         else{
            Wrtie-Host $_
         }
    }
}