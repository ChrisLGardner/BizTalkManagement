function Remove-BizTalkMessageInstances {
    param
    (
        [string]$ServiceStatus,
        [string]$PortName
    )

    # ServiceStatus = 1 Ready To Run
    # ServiceStatus = 2 Active
    # ServiceStatus = 4 Suspended (Resumable)
    # ServiceStatus = 8 Dehydrated
    # ServiceStatus = 16 Completed With Discarded Messages’ in BizTalk Server 2004
    # ServiceStatus = 32 Suspended (Not Resumable)
    # ServiceStatus = 64 In Breakpoint

    [array]$wmiQuery = $null
    if ($ServiceStatus -eq "*" -or [System.String]::IsNullOrEmpty($ServiceStatus)) {
        $wmiQuery = '1,2,4,8,32,64'
        $wmiQuery = $wmiQuery.Split(",")
    }
    else {
        $wmiQuery = $ServiceStatus.Split(",")
    }

    [array]$Messages = $null
    foreach ($statusCode in $wmiQuery) {
        $Messages += Get-WmiObject -Class MSBTS_ServiceInstance  -namespace "root\MicrosoftBizTalkServer" -filter "ServiceStatus =  $($statusCode)"
    }

    if ([System.String]::IsNullOrEmpty($PortName) -ne $true) {
        $Messages = $Messages | Where-Object {$_.ServiceName -eq $PortName}
    }
    foreach ($message in $Messages) {
        if ([string]::IsNullOrEmpty($PortName) -ne $true) {
            if ($message.ServiceName -eq $PortName) {
                $old_ErrorActionPreference = $ErrorActionPreference
                $ErrorActionPreference = "Ignore"
                $message.Terminate()
                $ErrorActionPreference = $old_ErrorActionPreference
            }
        }
        else {
            $message.Terminate()
        }
    }
}
