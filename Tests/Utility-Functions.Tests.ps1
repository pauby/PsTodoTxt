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

    Describe "Write-VerboseHashTable" {
        It "Should output a formatted hashtable in verbose mode" {
            $ht = @{ name = "joe"; surname = "bloggs"}
            # capture verbose output to a variable - pipe to out-string to get it all in one line
            $actual = (Write-VerboseHashTable $ht -v 4>&1) | Out-String
            $expected ="  Name      Value`r`n  ----      -----`r`n  name    : joe`r`n  surname : bloggs`r`n"
            $actual | Should Be $expected
        }
    }
}

Remove-Module PsTodoTxt