function Install-GacAssembly {
    param
    (
        $AssemblyName,
        $AssemblyLocation
    )
    [System.Reflection.Assembly]::Load("System.EnterpriseServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
    $settingsdll = Get-ChildItem -Path $AssemblyLocation -Filter $AssemblyName -Recurse
    $publish = New-Object System.EnterpriseServices.Internal.Publish
    if ($settingsdll -is [System.Array]) {
        $publish.GacInstall($($settingsdll[0].FullName))
    }
    else {
        $publish.GacInstall($($settingsdll.FullName))
    }
}
