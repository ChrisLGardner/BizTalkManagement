Import-Module "$PSScriptRoot\..\..\Output\BizTalkManagement.psd1" -Force

InModuleScope BizTalkManagement {
    Describe "Testing Install-GacAssembly" {
        $Sut = "Install-GacAssembly"

        Context "Testing inputs" {

            It "Should have an AssemblyName parameter" {
                (Get-Command $Sut).Parameters['AssemblyName'].Attributes.Mandatory | Should -BeFalse
            }

            It "Should have an AssemblyLocation parameter" {
                (Get-Command $Sut).Parameters['AssemblyLocation'].Attributes.Mandatory | Should -BeFalse
            }

            It "Should throw an exception when AssemblyLocation is invalid" {
                {&$Sut -AssemblyName 'Test' -AssemblyLocation C:\FakePath.txt} | Should -Throw "Unable to find C:\FakePath.txt"
            }

        }

        Context "Testing outputs" {

        }
    }
}
