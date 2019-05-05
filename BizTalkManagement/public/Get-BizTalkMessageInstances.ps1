function Get-BizTalkMessageInstances {
    param
    (
        [string]$ServiceStatus,
        [string]$PortName
    )


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
    else {
        $Messages
    }
}
