function Start-BizTalkOrchestration {
    param
    (
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [alias("OrchestrationName")]
        [string]$FullName
    )

    $TargetOrchestration = $null
    $Applications = $Script:BizTalkOM.Applications
    $Orchestrations = $null

    foreach ($Application in $Applications) {
        $Orchestrations += $Application.Orchestrations
    }
    $TargetOrchestration = $Orchestrations | Where-Object {$_.FullName -eq $FullName}

    $TargetOrchestration.Status = "Started"
    $Script:BizTalkOM.SaveChanges()
}
