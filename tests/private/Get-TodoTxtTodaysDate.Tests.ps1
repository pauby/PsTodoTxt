$ModuleName = 'PsTodoTxt'

. "$PSScriptRoot\..\SharedTestHelper.ps1"

$thisModule = Import-TestedModule -Name $ModuleName

Describe "Testing Function - Get-TodoTxtTodaysDate" {
    Context "Output" {

        InModuleScope PSTodoTxt {
            It "Should return todays date as a string" {
                $today = Get-Date -Format "yyyy-MM-dd"
                $today -eq (Get-TodoTxtTodaysDate) | Should Be $true
                $today | Should BeOfType String
            }
        } #InModuleScope
    } #Context
}
