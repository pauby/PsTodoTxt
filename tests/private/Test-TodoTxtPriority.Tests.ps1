$ModuleName = 'PsTodoTxt'

. "$PSScriptRoot\..\shared.ps1"

$thisScript = Get-TestedScript
Import-TestedModule | Out-Null

Describe "Testing Function - Test-TodoTxtDate" {
    InModuleScope PsTodoTxt {
        Context "Input" {
            It "Should throw an exception for null / empty input" {
                { Test-TodoTxtPriority -Priority "" } | Should throw "argument is null or empty"
            }
        }

        Context "Output" {
            It "should be false for invalid priority" {
                $actual = Test-TodoTxtPriority -Priority "9"
                $actual | Should Be $false
                $actual | Should BeOfType boolean
            }

            It "should be true for valid priority" {
                $actual = Test-TodoTxtPriority -Priority "A"
                $actual | Should Be $true
                $actual | Should BeOfType boolean

                $actual = Test-TodoTxtPriority -Priority "z"
                $actual | Should Be $true
                $actual | Should BeOfType boolean
            }
        } # Context
    } # InModuleScope

    Context "Code Analysis" {

        It 'passes all PSScriptAnalyser rules' {
            (Invoke-ScriptAnalyzer -Path $thisScript.Path).count | Should Be 0
        }
    }
}