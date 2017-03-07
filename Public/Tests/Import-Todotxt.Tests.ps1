$ourModule = 'PsTodoTxt'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

$functionName = $sut -replace '\.ps1'
$functionScript = Get-ChildItem $sut -Recurse | Select-Object -First 1
if ($null -eq $functionScript) {
    Write-Host "Cannot find the script $sut in any child directories. Will not check the code quality with PSScriptAnalyser." -ForegroundColor 'Red'
}

# Setup the PSScriptAnalyser Rules
try {
    $ExcludedPSSCriptAnalyserRules = Get-Variable -Name 'My_ExcludedPSScriptAnalyserRules' -Scope 'Global' -ValueOnly
}
catch {
    $ExcludedPSSCriptAnalyserRules = @()
}

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
            Mock -ModuleName $ourModule ConvertTo-TodoTxt { } # we don't care about calling the real function just measuring how many tiems it was called
            $todoFile = 'TESTDRIVE:todofile.txt'
            Add-Content -Path $todoFile -Value 'line 1'
            Add-Content -Path $todoFile -Value 'line 2'
            Import-TodoTxt -Path $todoFile
            Assert-MockCalled -ModuleName $ourModule -CommandName 'ConvertTo-TodoTxt' -Times 2
        }
    }

    Context "Output" {
        # the output comes from the ConvertFrom-TodoTxtString function. We tested this has been
        # called above so no further output tests needed
    }

    Context "Code Analysis" {
        if ($null -ne $functionScript) {
            if ($ExcludedPSSCriptAnalyserRules.Count -gt 0) {
                Write-Host "`nExcluded the following ScriptAnalyzer rules: `n    * $($ExcludedPSSCriptAnalyserRules -join '`n    * ')`n"
            }

            It 'passes all PSScriptAnalyser rules' {
                (Invoke-ScriptAnalyzer -Path $functionScript -ExcludeRule $ExcludedPSSCriptAnalyserRules).Count | Should Be 0
            }
        }
    }
}