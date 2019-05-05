function Get-BizTalkApplicationBackReferences {
    [cmdletbinding()]
    param
    (
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [alias("AppName")]
        [string]$Name,
        [switch]$Force
    )


    $app = $Script:BizTalkOM.Applications | Where-Object {$_.Name -eq $Name}
    if (!$Force) {
        $app.BackReferences
    }
    else {
        $app.BackReferences | Select-Object Name, Description, Status
    }
}
