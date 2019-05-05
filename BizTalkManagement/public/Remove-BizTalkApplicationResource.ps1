function Remove-BizTalkApplicationResource {
    param
    (
        [string]$ResourceLuid,
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [alias("ApplicationName")]
        [string]$Name
    )
    if ($env:Processor_Architecture -ne "x86") {
        # Get the command parameters
        $ArgumentList = "-Name $Name"
        $ArgumentList += " -ResourceLuid $ResourceLuid"

        $ModulePath = (Get-Module -Name "BizTalkAdministration_2013R2").Path
        write-warning "Re-launching in x86 PowerShell with $($ArgumentList -join ' ')"
        &"$env:windir\syswow64\windowspowershell\v1.0\powershell.exe" -noprofile -executionpolicy bypass -NoExit -Command "Import-Module $ModulePath; Remove-BizTalkApplicationResource $ArgumentList ;exit"
        exit
    }


    $app = Get-BizTalkInstanceApplications -AppPattern $Name -Force
    [System.reflection.Assembly]::LoadWithPartialName("Microsoft.BizTalk.Admin")
    [System.reflection.Assembly]::LoadWithPartialName("Microsoft.BizTalk.ApplicationDeployment.Engine")
    [System.reflection.Assembly]::LoadWithPartialName("System.EnterpriseServices")
    $lDepGroup = New-Object Microsoft.BizTalk.ApplicationDeployment.Group
    $lDepGroup.DBName = $dbName
    Write-Host "Connecting to DB:$dbName"
    $lDepGroup.DBServer = $dbInstance
    Write-Host "Connecting to Server:$dbInstance"
    $appName = $Name
    Write-Host "Connecting to application:$($appName)"

    Write-Host "lDepGroup Object configured with the following"
    Write-Host "DbServer:$($lDepGroup.DBServer)"
    Write-Host "DbName:$($lDepGroup.DBName)"

    Write-Host "Connection Status"
    if ($null -eq $lDepGroup.SqlConnection.State) {
        Write-Host "Failed to open SQL connection to $($lDepGroup.DbServer),$($lDepGroup.DBName)"
    }

    [Microsoft.BizTalk.ApplicationDeployment.Application]$lApp = $lDepGroup.Applications["$appName"]
    if ($null -eq $lApp) {
        Write-Host "Specified app:$appName was not found in deployment group"
    }
    else {


        $resourceToRemove = $null
        $resources = $lApp.ResourceCollection

        foreach ($resource in $resources) {
            $installedLuid = $resource.Luid
            if ($installedLuid -eq $ResourceLuid) {
                $resourceToRemove = $resource
            }
        }
        $ErrorActionPreference = "Stop"
        try {
            Write-Verbose -Message "Attempting to remove $($resourceToRemove.Luid)"
            $lApp.RemoveResource($resourceToRemove.ResourceType, $resourceToRemove.Luid)
            Write-Output "Removal succeeded, committing transaction"
            $lDepGroup.Commit()
            Write-Output $true
        }
        catch {
            Write-Verbose -Message "Removal failed, rolling back transaction"
            $lDepGroup.Abort()
            Write-Output $false

        }
        finally {
            Write-Verbose -Message "Disposing connections."
            $lApp.Dispose()
            $lDepGroup.Dispose()
            $ErrorActionPreference = "Continue"
        }
    }
    $ErrorActionPreference = "SilentlyContinue"
    $lApp.Dispose()
    $lDepGroup.Dispose()
    $ErrorActionPreference = "Continue"
}
