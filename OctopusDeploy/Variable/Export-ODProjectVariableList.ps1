function Export-ODProjectVariableList($ProjectName,$ProjGroupNames,$OutputLocation="C:\temp\"){

        $OctoProjs = @()
		
		If($ProjGroupNames){
		    $ProGroups = @()
			foreach($pjName in $ProjGroupNames){
				$ProGroups += $octo.ProjectGroups.FindByName($pjName)
			}
			$OctoProjs = $octo.Projects.FindAll() | Where-Object { $ProGroups.Id -contains $_.ProjectGroupId -and $_.IsDisabled -eq $false }
		}
		else{
			 $OctoProjs = Get-ODProject -ProjectName $ProjectName
		}        
		
        if($ProjectName -and $ProjGroupNames){
			$OctoProjs = $OctoProjs | Where-Object { $_.Name -eq $ProjectName}
        }     

        foreach($OctoProj in $OctoProjs){

            $ProjVariables = @()            
                        
            $ProjVariables = Get-ODProjectVariableList -ProjectName $OctoProj.Name

            if( $ProjVariables ){
                $ProjVariables | Export-Csv -NoTypeInformation "$OutputLocation\$($OctoProj.Name).csv" -Force
                Write-Verbose "Exported Variables to $OutputLocation"
            }
        }

        #Now working on Shared Library variable set
        Write-Verbose "Collecting Library Sets"
        $LibSets = $OctoProjs | Select-Object -ExpandProperty IncludedLibraryVariableSetIds -Unique

        foreach($libset in $LibSets) {            
            $results =@()
            $libVariableSets = $octo.LibraryVariableSets.Get($libset)

            if($libVariableSets.ContentType -ne 'ScriptModule'){

                Write-Verbose "Exporting Library Set $($libVariableSets.Name)"

                foreach($lSet in $libVariableSets){                
                     $results += Get-ODVariableList -variableSetId $($lSet.VariableSetId)                        
                }

                if( $results ){                    
                    $results | Export-Csv -NoTypeInformation "$OutputLocation\$($libVariableSets.Name).csv" -Force
                    Write-Verbose "Exported Library Set to $OutputLocation"
                }
            }
        }
}