$ModuleName = 'PsTodoTxt'

. "$PSScriptRoot\..\SharedTestHelper.ps1"

$thisScript = Get-TestedScript
Import-TestedModule | Out-Null

Describe "Testing Function - Get-TodoTxtTodaysDate" {
    Context "Output" {

        InModuleScope PSTodoTxt {
            It "Should return todays date as a string" {
                $today = Get-Date -Format "yyyy-MM-dd"
                $today -eq (Get-TodoTxtTodaysDate) | Should Be $true
                $today | Should BeOfType String
            }
        }
    }

    Context "Code Analysis" {

        It 'passes all PSScriptAnalyser rules' {
            (Invoke-ScriptAnalyzer -Path $thisScript.Path).count | Should Be 0
        }
    }
}
