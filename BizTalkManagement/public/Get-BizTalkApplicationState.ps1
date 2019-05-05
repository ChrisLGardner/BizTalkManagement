function Get-BizTalkApplicationState {
    param
    (
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [alias("AppName")]
        [string]$Name
    )

    if ($null -eq $appName -or $appName -eq "*") {
        $Script:BizTalkOM.Applications | Select-Object Name, Status
    }
    else {
        $Script:BizTalkOM.Applications | Where-Object {$_.Name -eq "$Name"} | Select-Object Name, Status
    }

}
