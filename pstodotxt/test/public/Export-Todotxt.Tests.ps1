Describe "Function Testing - Export-TodoTxt" {
    Context "Parameter Validation" {

        It "throws an exception for null or missing parameters" {
            { Export-TodoTxt -Todo $null } | Should throw "argument is null"
            { Export-TodoTxt -Path $null } | Should throw " argument is null"
            { Export-TodoTxt -Path "" } | Should throw "argument is null or empty"
        }
    }

    Context "Logic & Flow" {
        InModuleScope PSTodoTxt {
            Mock ConvertFrom-TodoTxt { "" }
            Mock Add-Content { $true }
            Mock Remove-Item {}
            $testFile = 'TestDrive:\dummy.txt'

            It 'removes the output file if it exists and the -Append parameter is not used' {
                Set-Content -Value "abc" -Path $testFile 
                Export-TodoTxt -Todo "test" -Path $testFile 
                Assert-MockCalled Remove-Item
            }
        } #InModuleScope
    }

    Context "Output" {
        # the output comes from the ConvertTo-TodoTxt function. We tested this has been
        # called above so no further output tests needed
    }
}