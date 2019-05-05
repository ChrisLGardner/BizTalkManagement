function Get-BizTalkInstanceApplications {
    Param
    (
        [alias("AppName")]
        [string]$AppPattern,
        [switch]$Force
    )
    if ($AppPattern -eq $null -or $AppPattern -eq "*") {
        if (!$Force) {
            return $Script:BizTalkOM.Applications | Select-Object Name, Description, Status
        }
        else {
            return $Script:BizTalkOM.Applications
        }
    }
    else {
        if (!$Force) {
            return $Script:BizTalkOM.Applications | Where-Object {$_.Name -match "$AppPattern"} | Select-Object Name, Description, Status
        }
        else {
            return $Script:BizTalkOM.Applications | Where-Object {$_.Name -match "$AppPattern"}
        }
    }
}
