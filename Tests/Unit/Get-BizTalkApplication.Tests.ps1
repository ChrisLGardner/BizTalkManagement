Import-Module "$PSScriptRoot\..\..\Output\BizTalkManagement.psd1" -Force

InModuleScope BizTalkManagement {
    Describe "Testing Get-BizTalkApplication" {
        $Sut = "Get-BizTalkApplication"

        Context "Testing inputs" {

            It "Should have Name as an optional parameter" {
                (Get-Command $Sut).Parameters['Name'].Attributes.Mandatory | Should -BeFalse
            }

            It "Should have AppName, Application and ApplicationName as aliases on the Name parameter" {
                (Get-Command $Sut).Parameters['Name'].Aliases | Should -Be @('AppName', 'Application', 'ApplicationName')
            }

            It "Should accept ValueFromPipeline for Name parameter" {
                (Get-Command $Sut).Parameters['Name'].Attributes.ValueFromPipeline | Should -BeTrue
            }

            It "Should accept ValueFromPipelineByPropertyName for Name parameter" {
                (Get-Command $Sut).Parameters['Name'].Attributes.ValueFromPipelineByPropertyName | Should -BeTrue
            }
        }

        Context "Testing outputs" {

        }
    }
}
