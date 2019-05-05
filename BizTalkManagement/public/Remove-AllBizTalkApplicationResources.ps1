function Remove-AllBizTalkApplicationResources {
    param
    (
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [alias("ApplicationName")]
        [string]$Name
    )

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
        Write-Output "Application $appName contains the following resources."
        $resources = $lApp.ResourceCollection
        foreach ($resource in $resources) {
            Write-Output $resource.Luid
        }

        $ErrorActionPreference = "Stop"
        try {
            Write-Output "Attempting to remove all resources for $appName"
            $lApp.RemoveResources($resources)
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
