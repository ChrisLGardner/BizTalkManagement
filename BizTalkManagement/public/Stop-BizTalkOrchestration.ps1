function Stop-BizTalkOrchestration {
    param
    (
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [alias("OrchestrationName")]
        [string]$FullName,
        [switch]$Force

    )

    $TargetOrchestration = $null
    $Applications = $Script:BizTalkOM.Applications
    $Orchestrations = $null

    foreach ($Application in $Applications) {
        $Orchestrations += $Application.Orchestrations
    }
    $TargetOrchestration = $Orchestrations | Where-Object {$_.FullName -eq $FullName}

    if ($Force) {
        $TargetOrchestration.Status = "Unenlisted"
    }
    else {
        $TargetOrchestration.Status = "Enlisted"
    }
    $Script:BizTalkOM.SaveChanges()
}
