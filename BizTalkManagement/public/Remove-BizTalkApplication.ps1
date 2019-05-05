function Remove-BizTalkApplication {
    param
    (
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [alias("ApplicationName")]
        [string]$Name,
        [switch]$Force
    )

    if ($env:Processor_Architecture -ne "x86") {
        # Get the command parameters
        $ArgumentList = "-Name $Name"
        if ($force) {
            $ArgumentList += " -force"
        }
        $ModulePath = (Get-Module -Name "BizTalkAdministration_2013R2").Path
        write-warning "Re-launching in x86 PowerShell with $($ArgumentList -join ' ')"
        &"$env:windir\syswow64\windowspowershell\v1.0\powershell.exe" -noprofile -executionpolicy bypass -NoExit -Command "Import-Module $ModulePath; Remove-BizTalkApplication $ArgumentList ;exit"
        exit
    }


    $App = Get-BizTalkInstanceApplications -AppPattern $Name -Force
    $appSendPorts = $App.SendPorts
    $appSendGroupPorts = $App.SendPortGroups
    $appReceivePorts = $App.ReceivePorts
    $appBackReferences = $App.BackReferences

    if ($appBackReferences.Count -gt 0 -and $Force -ne $true) {
        $Message = "$($App.Name) has back references which will block uninstallation. Please re-run this command with the -Force switch set to $true.
        ` WARNING this will remove ALL referencing applications prior to uninstalling the desired application!"
        Write-Warning $Message
        exit
    }
    if ($appBackReferences.Count -gt 0 -and $Force -eq $true) {
        foreach ($backApp in $appBackReferences) {
            Remove-BizTalkApplication -Name $backApp.Name -Force
        }
    }
    #Terminate All Messages
    Remove-BizTalkMessageInstances -ServiceStatus "*" -ApplicationName $App.Name -PortName $null

    #Stop all Orchestrations
    $Orchestrations = $App.Orchestrations
    foreach ($Orchestration in $Orchestrations) {
        Stop-BizTalkOrchestration $Orchestration.FullName -Force
        Remove-OrchestrationBindings -Orchestration $Orchestration.FullName

    }

    #Remove all Send Port Groups
    foreach ($SendPortGroup in $appSendGroupPorts) {
        Stop-BizTalkSendPortGroup $SendPortGroup
        $Script:BizTalkOM.RemoveSendPortGroup($SendPortGroup)
        $Script:BizTalkOM.SaveChanges()
    }

    #Remove all Receive Ports
    foreach ($ReceivePort in $appReceivePorts) {
        Stop-BizTalkReceivePort $ReceivePort
        $Script:BizTalkOM.RemoveReceivePort($ReceivePort)
        $Script:BizTalkOM.SaveChanges()
    }

    #Remove all Send Ports
    foreach ($SendPort in $appSendPorts) {
        Stop-BizTalkSendPort -Name $SendPort.Name -Force
        $Script:BizTalkOM.RemoveSendPort($SendPort)
        $Script:BizTalkOM.SaveChanges()
    }

    #Remove Application Resources
    Remove-AllBizTalkApplicationResources -App $App.Name

    $Script:BizTalkOM = New-Object Microsoft.BizTalk.ExplorerOM.BtsCatalogExplorer
    $Script:BizTalkOM.ConnectionString = "SERVER=$dbInstance;DATABASE=$dbName;Integrated Security=SSPI"
    $App = Get-BizTalkInstanceApplications -AppPattern $Name -Force
    $App.BtsCatalogExplorer.RemoveApplication($App)
    $Script:BizTalkOM.SaveChanges()
}
