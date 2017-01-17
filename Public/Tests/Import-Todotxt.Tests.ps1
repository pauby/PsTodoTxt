$ourModule = 'PsTodoTxt'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$functionName = $sut -replace '\.ps1'

if (Test-Path -Path "$ourModule.psd1") {
    Remove-Module $ourModule -ErrorAction SilentlyContinue
    Import-Module ".\$ourModule.psd1" -Force
}
else {
    throw "Module .\$ourModule.psd1 not found in current directory" 
}

Describe "Function Testing - $($functionName)" {
    Context "Parameter Validation" {
        It "throws an exception for missing import file" {
            { Import-TodoTxt -Path 'TestDrive:missingfile.txt'  } | Should throw "Cannot validate argument on parameter 'Path'"
        }
    }

    Context "Processing and Logic" {
        It 'returns $null for empty todo file' {
            $emptyFile = 'TestDrive:empty.txt'
            Add-Content -Path $emptyFile -Value ''
            Clear-Content -Path $emptyFile 
            Import-TodoTxt -Path $emptyFile | Should Be $null
        }

        It 'returns todo objects when give strings' {
            # this tests the flow of the function not the Output
            Mock -ModuleName $ourModule ConvertFrom-TodoTxtString { } # we don't care about calling the real function just measuring how many tiems it was called
            $todoFile = 'TESTDRIVE:todofile.txt'
            Add-Content -Path $todoFile -Value 'line 1'
            Add-Content -Path $todoFile -Value 'line 2'
            Import-TodoTxt -Path $todoFile
            Assert-MockCalled -ModuleName $ourModule -CommandName 'ConvertFrom-TodoTxtString' -Times 2
        }
    }

    Context "Output" {
        # the output comes from the ConvertFrom-TodoTxtString function. We tested this has been 
        # called above so no furterh output tests needed 
    }
}