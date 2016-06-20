$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Utility-Functions" {
    Context "Testing function Get-TodoTxtTodaysDate" {
        It "returns todays date" {
            $today = Get-Date -Format "yyy-MM-dd"
            $today -eq (Get-TodoTxtTodaysDate) | Should Be $true
        }
    }

    Context "Testing function Write-VerboseHashTable" {
        It "writes a formatted hashtable in verbose mode" {
            $ht = @{ name = "joe"; surname = "bloggs"}
            # capture verbose output to a variable - pipe to out-string to get it all in one line
            $actual = (Write-VerboseHashTable $ht -v 4>&1) | Out-String
            $expected ="  Name      Value`r`n  ----      -----`r`n  name    : joe`r`n  surname : bloggs`r`n"
            $actual | Should Be $expected
        }
    }
}
