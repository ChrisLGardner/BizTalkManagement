function Get-BizTalkApplicationReferences {
    param
    (
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [alias("AppName")]
        [string]$Name,
        [switch]$Force
    )


    $app = $Script:BizTalkOM.Applications | Where-Object {$_.Name -eq $Name}
    if (!$Force) {
        return $app.References
    }
    else {
        return $app.References | Select-Object Name, Description, Status
    }
}
