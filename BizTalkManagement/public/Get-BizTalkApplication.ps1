function Get-BizTalkApplication {
    [cmdletbinding()]
    param (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('AppName', 'Application', 'ApplicationName')]
        [string]$Name
    )

    $Script:BizTalkOM.Applications | Where-Object {$_.Name -like "*$Name*"}
}
