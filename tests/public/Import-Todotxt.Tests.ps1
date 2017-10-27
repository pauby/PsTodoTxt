$ModuleName = 'PsTodoTxt'

. "$PSScriptRoot\..\shared.ps1"

$thisScript = Get-TestedScript
Import-TestedModule | Out-Null

Describe "Function Testing - Import-TodoTxt" {
    Context "Parameter Validation" {

        It "throws an exception for missing import file" {
            { Import-TodoTxt -Path 'TestDrive:missingfile.txt'  } | Should throw "Cannot validate argument on parameter 'Path'"
        }
    }

    Context "Logic & Flow" {

        It 'returns $null for empty todo file' {
            $emptyFile = 'TestDrive:empty.txt'
            Add-Content -Path $emptyFile -Value ''
            Clear-Content -Path $emptyFile
            Import-TodoTxt -Path $emptyFile | Should Be $null
        }

        It 'returns todo objects when give strings' {
            # this tests the flow of the function not the Output
            Mock -ModuleName $ModuleName ConvertTo-TodoTxt { } # we don't care about calling the real function just measuring how many tiems it was called
            $todoFile = 'TESTDRIVE:todofile.txt'
            Add-Content -Path $todoFile -Value 'line 1'
            Add-Content -Path $todoFile -Value 'line 2'
            Import-TodoTxt -Path $todoFile
            Assert-MockCalled -ModuleName $ModuleName -CommandName 'ConvertTo-TodoTxt' -Times 2
        }
    }

    Context "Output" {
        # the output comes from the ConvertFrom-TodoTxtString function. We tested this has been
        # called above so no further output tests needed
    }

    Context "Code Analysis" {

        It 'passes all PSScriptAnalyser rules' {
            (Invoke-ScriptAnalyzer -Path $thisScript.Path).Count | Should Be 0
        }
    }
}