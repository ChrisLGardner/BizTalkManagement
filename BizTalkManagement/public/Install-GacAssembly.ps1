function Install-GacAssembly {
    [cmdletbinding()]
    param
    (
        [Parameter()]
        [string]$AssemblyName,

        [Parameter()]
        [ValidateScript( {
                if (-not(Test-Path -Path $_)) {
                    $PSCmdlet.ThrowTerminatingError(
                        (New-Object -TypeName System.Management.Automation.ItemNotFoundException -ArgumentList "Unable to find $_")
                    )
                }
                $true
            })]
        [System.Io.FileInfo]$AssemblyLocation
    )

    Add-Type -AssemblyName "System.EnterpriseServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"

    $settingsdll = Get-ChildItem -Path $AssemblyLocation -Filter $AssemblyName -Recurse | Select-Object -First 1
    $publish = New-Object System.EnterpriseServices.Internal.Publish

    $publish.GacInstall($settingsdll.FullName)
}
