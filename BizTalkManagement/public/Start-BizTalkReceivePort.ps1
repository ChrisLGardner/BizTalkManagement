function Start-BizTalkReceivePort {
    param
    (
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [alias("ReceivePortName")]
        [string]$Name
    )

    $Port = $null
    $Port = $Script:BizTalkOM.ReceivePorts | Where-Object {$_.Name -eq $Name}

    if ($null -ne $Port) {
        $ReceivePortLocations = $Port.ReceiveLocations
        foreach ($Location in $ReceivePortLocations) {
            $Location.Enable = $true
            $Script:BizTalkOM.SaveChanges()
        }
    }
}
