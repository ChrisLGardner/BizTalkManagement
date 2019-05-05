function Start-BizTalkSendPortGroup {
    param
    (
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [alias("SendPortGroupName")]
        [string]$Name
    )

    $SendPortGroup = $null
    $SendPortGroup = $Script:BizTalkOM.SendPortGroups | Where-Object {$_.Name -eq $Name}
    $SendPortGroup.Status = "Started"
    $Script:BizTalkOM.SaveChanges()
}
