
Describe "Testing Function - $($Function.Name) - Functional Processing" {
    InModuleScope PSTodoTxt {
        It "Should return todays date as a string" {
            $today = Get-Date -Format "yyyy-MM-dd"
            $today -eq (Get-TodoTxtTodaysDate) | Should Be $true
            $today | Should BeOfType String
        }
    }
}
