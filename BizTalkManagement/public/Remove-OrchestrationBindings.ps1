function Remove-OrchestrationBindings {
    param
    (

        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [alias("OrchestrationName")]
        [string]$FullName
    )

    $Orch = $null
    $Orch = Get-BizTalkOrchestration $FullName
    [array]$Ports = $Orch.Ports
    foreach ($Port in $Ports) {
        $Port.SendPort = $null
        $Port.ReceivePort = $null
        $Script:BizTalkOM.SaveChanges()
    }
}
