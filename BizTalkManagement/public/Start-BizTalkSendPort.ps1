function Start-BizTalkSendPort {
    param
    (
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [alias("SendPortName")]
        [string]$Name
    )


    $Port = $Script:BizTalkOM.SendPorts | Where-Object {$_.Name -eq $Name}
    if ($null -ne $Port) {
        $Port.Status = "Started"
    }
    $Script:BizTalkOM.SaveChanges()
}
