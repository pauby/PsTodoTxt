$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = Split-Path -Parent $here
Import-Module $here\PsTodoTxt

InModuleScope PsTodoTxt {

    Describe "Get-TodoTxtTodaysDate" {
        It "Should return todays date as a string" {
            $today = Get-Date -Format "yyyy-MM-dd"
            $today -eq (Get-TodoTxtTodaysDate) | Should Be $true
            $today | Should BeOfType String
        }
    }
}

Remove-Module PsTodoTxt