Import-PTHBuildModule
$functionName = $MyInvocation.MyCommand -split '.tests.ps1'

Describe "Function Testing - $functionName" {
    InModuleScope -ModuleName PsTodoTxt {
        Context "Parameter Validation" {
            It "throws an exception for missing import file" {
                { Import-TodoTxt -Path 'TestDrive:missingfile.txt'  } | Should throw "Cannot validate argument on parameter 'Path'"
            }
        }

        Context "Logic & Flow" {
            It 'returns $null for empty todo file' {
                $emptyFile = 'TestDrive:\empty.txt'
                Add-Content -Path $emptyFile -Value ''
                Clear-Content -Path $emptyFile
                Import-TodoTxt -Path $emptyFile | Should Be $null
            }

            It 'returns todo objects when given strings' {
                # this tests the flow of the function not the Output we don't
                # care about calling the real function just measuring how many
                # times it was called
                Mock -ModuleName PSTodoTxt ConvertTo-TodoTxt { } 
                $todoFile = 'TESTDRIVE:\todofile.txt'
                Add-Content -Path $todoFile -Value 'line 1'
                Add-Content -Path $todoFile -Value 'line 2'
                Import-TodoTxt -Path $todoFile
                Assert-MockCalled -ModuleName PSTodoTxt -CommandName 'ConvertTo-TodoTxt' -Times 2
            }

            It 'returns todo objects when given strings that are empty and non-empty' {
                # this tests the flow of the function not the Output
                Mock -ModuleName PSTodoTxt ConvertTo-TodoTxt { } # we don't care about calling the real function just measuring how many times it was called
                $todoFile = 'TESTDRIVE:\todofile.txt'
                Add-Content -Path $todoFile -Value 'line 1'
                Add-Content -Path $todoFile -Value ''
                Add-Content -Path $todoFile -Value ''
                Add-Content -Path $todoFile -Value 'line 2'
                Import-TodoTxt -Path $todoFile
                Assert-MockCalled -ModuleName PSTodoTxt -CommandName 'ConvertTo-TodoTxt' -Times 2
            }
        }

        Context "Output" {
            # the output comes from the ConvertTo-TodoTxt function. We tested this has been
            # called above so no further output tests needed
        }
    } #InModuleScope
}