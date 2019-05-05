function Stop-BizTalkSendPort {
    param
    (
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [alias("SendPortName")]
        [string]$Name,
        [switch]$Force
    )
    $Port = $null
    $Port = $Script:BizTalkOM.SendPorts | Where-Object {$_.Name -eq $Name}

    if ($null -ne $Port) {
        if ($Force) {
            $Port.Status = "Bound"
        }
        else {
            $Port.Status = "Stopped"
        }
    }
    $Script:BizTalkOM.SaveChanges()
}
