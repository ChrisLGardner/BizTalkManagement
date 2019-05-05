function Get-BizTalkDefaultApplication {
    $Script:BizTalkOM.Applications | Where-Object {$_.IsDefaultApplication -eq "True"}
}
