Import-HelperModuleForTesting
$functionName = $MyInvocation.MyCommand -split '.tests.ps1'

Describe "Testing Function - $functionName" {

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
