function Set-BizTalkApplicationState {
    # declare -stop -start switch parameters
    param
    (
        [switch] $start,
        [switch] $stop,
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [alias("AppName")]
        [System.Object[]]$Name,
        [switch]$Force
    )


    if ($null -eq $Name -or $Name -eq "*" -or [System.String]::IsNullOrEmpty($Name) -eq $true) {
        if ($stop -and $Force) {
            $Script:BizTalkOM.Applications | where-object {$_.status -eq "started"}  | ForEach-Object { $_.stop("StopAll")}
            $Script:BizTalkOM.SaveChanges()
        }
        if ($stop -and $null -eq $Force -or $stop -and $false -eq $Force) {
            $Script:BizTalkOM.Applications | ForEach-Object { $_.stop("DisableAllReceiveLocations")}
            $Script:BizTalkOM.Applications | ForEach-Object { $_.stop("UndeployAllPolicies")}
            $Script:BizTalkOM.Applications | ForEach-Object { $_.stop("UnenlistAllOrchestrations")}
            $Script:BizTalkOM.Applications | ForEach-Object { $_.stop("UnenlistAllSendPortGroups")}
            $Script:BizTalkOM.Applications | ForEach-Object { $_.stop("UnenlistAllSendPorts")}
            $Script:BizTalkOM.SaveChanges()
        }
        if ($start -and $Force) {
            $Script:BizTalkOM.Applications | where-object {$_.status -eq "stopped"}  | ForEach-Object { $_.start("StartAll")}
            $Script:BizTalkOM.SaveChanges()
        }
        if ($start -and !$Force) {
            $Script:BizTalkOM.Applications | where-object {$_.status -eq "stopped"}  | ForEach-Object { $_.start("DeployAllPolicies")}
            $Script:BizTalkOM.Applications | where-object {$_.status -eq "stopped"}  | ForEach-Object { $_.start("EnableAllReceiveLocations")}
            $Script:BizTalkOM.Applications | where-object {$_.status -eq "stopped"}  | ForEach-Object { $_.start("StartAllSendPortGroups")}
            $Script:BizTalkOM.Applications | where-object {$_.status -eq "stopped"}  | ForEach-Object { $_.start("StartAllSendPorts")}
            $Script:BizTalkOM.Applications | where-object {$_.status -eq "stopped"}  | ForEach-Object { $_.start("StartAllOrchestrations")}
            $Script:BizTalkOM.SaveChanges()
        }
    }
    else {
        foreach ($var in $Name) {
            if ($stop -and $Force) {
                $Script:BizTalkOM.Applications | where-object {$_.Name -eq "$var"}  | ForEach-Object { $_.stop("StopAll")}
                $Script:BizTalkOM.SaveChanges()
            }
            if ($stop -and $null -eq $Force -or $stop -and $false -eq $Force) {
                $Script:BizTalkOM.Applications | where-object {$_.Name -eq "$var"}  | ForEach-Object { $_.stop("DisableAllReceiveLocations")}
                $Script:BizTalkOM.Applications | where-object {$_.Name -eq "$var"}  | ForEach-Object { $_.stop("UndeployAllPolicies")}
                $Script:BizTalkOM.Applications | where-object {$_.Name -eq "$var"}  | ForEach-Object { $_.stop("UnenlistAllOrchestrations")}
                $Script:BizTalkOM.Applications | where-object {$_.Name -eq "$var"}  | ForEach-Object { $_.stop("UnenlistAllSendPortGroups")}
                $Script:BizTalkOM.Applications | where-object {$_.Name -eq "$var"}  | ForEach-Object { $_.stop("UnenlistAllSendPorts")}
                $Script:BizTalkOM.SaveChanges()
            }
            if ($start -and $null -ne $Name -and $Force) {
                $Script:BizTalkOM.Applications | where-object {$_.Name -eq "$var"}  | ForEach-Object { $_.start("StartAll")}
                $Script:BizTalkOM.SaveChanges()
            }
            if ($start -and $null -ne $Name -and !$Force) {
                $Script:BizTalkOM.Applications | where-object {$_.Name -eq "$var"}  | ForEach-Object { $_.start("DeployAllPolicies")}
                $Script:BizTalkOM.Applications | where-object {$_.Name -eq "$var"}  | ForEach-Object { $_.start("EnableAllReceiveLocations")}
                $Script:BizTalkOM.Applications | where-object {$_.Name -eq "$var"}  | ForEach-Object { $_.start("StartAllSendPorts")}
                $Script:BizTalkOM.Applications | where-object {$_.Name -eq "$var"}  | ForEach-Object { $_.start("StartAllSendPortGroups")}
                $Script:BizTalkOM.Applications | where-object {$_.Name -eq "$var"}  | ForEach-Object { $_.start("StartAllOrchestrations")}
                $Script:BizTalkOM.SaveChanges()
            }
        }
    }
}
