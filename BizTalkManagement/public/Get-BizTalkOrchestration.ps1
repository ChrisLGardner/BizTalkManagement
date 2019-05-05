function Get-BizTalkOrchestration {
    param
    (
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [alias("OrchestrationName", "Name")]
        [string]$FullName
    )

    $Applications = $Script:BizTalkOM.Applications
    $Orchestrations = $null
    foreach ($Application in $Applications) {
        $Orchestrations += $Application.Orchestrations
    }
    $Orchestrations | Where-Object {$_.FullName -match "$FullName"}
}
