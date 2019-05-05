function Set-BizTalkDefaultApplication {
    param
    (
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [alias("ApplicationName")]
        [string]$Name
    )
    $BizTalkApp = $Script:BizTalkOM.Applications[0].BtsCatalogExplorer.Applications | Where-Object {$_.Name -eq $Name}
    $Script:BizTalkOM.Applications[0].BtsCatalogExplorer.DefaultApplication = $BizTalkApp
    $Script:BizTalkOM.Applications[0].BtsCatalogExplorer.SaveChanges()
}
