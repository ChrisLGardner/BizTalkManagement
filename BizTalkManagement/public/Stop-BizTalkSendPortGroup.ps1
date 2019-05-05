function Stop-BizTalkSendPortGroup {
    param
    (
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [alias("SendPortGroupName")]
        [string]$Name
    )

    $SendPortGroup = $null
    $SendPortGroup = $Script:BizTalkOM.SendPortGroups | Where-Object {$_.Name -eq $Name}
    $SendPortGroup = $BizTalkSendPortGroup
    $SendPortGroup.Status = "Bound"
    $Script:BizTalkOM.SaveChanges()
}
