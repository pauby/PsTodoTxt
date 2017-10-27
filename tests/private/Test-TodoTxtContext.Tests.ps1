$ModuleName = 'PsTodoTxt'

. "$PSScriptRoot\..\SharedTestHelper.ps1"

$thisScript = Get-TestedScript
Import-TestedModule | Out-Null

Describe "Testing Function - Test-TodoTxtContext" {
    InModuleScope PsTodoTxt {
        Context "Input" {
            It "Should throw an exception for null / empty input" {
                { Test-TodoTxtContext -Context "" } | Should throw "argument is null or empty"
            }
        }

        Context "Output" {
            It "should be true for a single valid context (starting with @)" {
                $actual = Test-TodoTxtContext -Context "@hello"
                $actual | Should Be $true
                $actual | Should BeOfType boolean
            }

            It "should be false for a single invalid context (containing a space)" {
                $actual = Test-TodoTxtContext -Context "h ello"
                $actual | Should Be $false
                $actual | Should BeOfType boolean
            }

            It "should be false for a invalid context array" {
                $actual = Test-TodoTxtContext -Context @("so-long", "fairwell", "auf-Wiedersehen", "@goodnight")
                $actual | Should Be $false
                $actual | Should BeOfType boolean
            }

            It "should be true for a valid context array" {
                $actual = Test-TodoTxtContext -Context @("@so-long", "@fairwell", "+auf-Wiedersehen", "+goodnight")
                $actual | Should Be $true
                $actual | Should BeOfType boolean
            }
        }
    } # InModuleScope

    Context "Code Analysis" {

        It 'passes all PSScriptAnalyser rules' {
            (Invoke-ScriptAnalyzer -Path $thisScript.Path).count | Should Be 0
        }
    }
}