#Requires -Module Pester

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
    InModuleScope -ModuleName $ourModule {
        Context "Parameter Validation" -Tag 'ValidParams' {
            # as all parameters are validate in the code of the function the tests are below
        }

        Context "Processing and Logic" -Tag 'Proc' {

            Mock Test-TodoTxtDate { return $false }
            Mock Test-TodoTxtPriority { return $false }
            Mock Test-TodoTxtContext { return $false }

            $tests = @(
                @{  'name'          = 'missing CreatedDate';
                    'testObject'    = (New-Object -TypeName PSObject -Property @{ 'Task' = 'Rescue Han from Jabba' })
                },
                @{  'name'          = 'missing Task';
                    'testObject'    = (New-Object -TypeName PSObject -Property @{ 'CreatedDate' = '2017-01-01'} )
                }
            )
            It 'will return $false for missing parameters - <name>' -TestCases $tests {
                Param (
                    $testObject
                )

                ($testObject | Test-TodoTxt) | Should Be $false
            }

            $tests = @(
                @{  'name'          = 'invalid DoneDate';
                    'testObject'    = (New-Object -TypeName PSObject -Property @{ 'DoneDate' = '2019-01-99'; 'CreatedDate' = '2016-01-01'; 'Task' = 'Rescue Han from Jabba' });
                    'mockFunction'  = 'Test-TodoTxtDate'
                },
                @{  'name'          = 'invalid Priority';
                    'testObject'    = (New-Object -TypeName PSObject -Property @{ 'Priority' = '1'; 'CreatedDate' = '2016-01-01'; 'Task' = 'Rescue Han from Jabba' });
                    'mockFunction'  = 'Test-TodoTxtPriority'
                },
                @{  'name'          = 'invalid Context';
                    'testObject'    = (New-Object -TypeName PSObject -Property @{ 'Context' = @('a b c'); 'CreatedDate' = '2016-01-01'; 'Task' = 'Rescue Han from Jabba' });
                    'mockFunction'  = 'Test-TodoTxtContext'
                }
            )

            It 'will return $false for invalid parameters - <name>' -TestCases $tests {
                Param (
                    $testObject, $mockFunction

                )

                ($testObject | Test-TodoTxt) | Should Be $false
                Assert-MockCalled $mockFunction -Times 1
            }
        }

        Context "Output" -Tag 'Output' {

            Mock Test-TodoTxtDate { return $true }
            Mock Test-TodoTxtPriority { return $true }
            Mock Test-TodoTxtContext { return $true }

            It 'will return valid output' {
                $testObject = (New-Object -TypeName PSObject -Property @{ 'DoneDate' = '2018-08-15'; Priority = 'K'; 'CreatedDate' = '2016-01-01';
                    'Task' = 'Rescue Han from Jabba'; 'Context' = @('palace', 'jabba'); 'Project' = @('rescue', 'rescue-han'); 'Addon' = @{ 'due' = '2087-12-09'; 'help' = 'luke'} });

                ($testObject | Test-TodoTxt) | Should Be $true
            }
        }
    } #end InModuleScope

    Context "Code Analysis" -Tag 'CodeCheck' {
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

<#
Describe "Testing Function - $($Function.Name) - Functional Processing & Logic" {
    InModuleScope PSTodoTxt {
        Context "Testing parameters input" {
            $invalidTodotxt = New-Object -TypeName PSObject -Property @{ CreatedDate = "2017-09-88"; Task = "Lets go to the Degobah system" }
            $validTodoTxtArr = @( (New-Object -TypeName PSObject -Property @{ DoneDate = "2015-10-09"; CreatedDate = "2016-09-15"; Task = "LEIA!"; Context = "deathstar"; Project = @("rebels", "hoth"); Addon = @{ due = "2018-09-09"} } ),
                    (New-Object -TypeName PSObject -Property @{ CreatedDate = "2016-09-15"; Priority = "G"; Task = "You're a little short to be a stormtrooper?"; Context = "deathstar"; Project = "prison" } )
                    )

            It "Passes testing for null and / or missing mandatory parameter" {
                { Test-TodoTxt -CreatedDate $null } | Should throw "null"
                { Test-TodoTxt -CreatedDate "" } | Should throw "empty"
                { Test-TodoTxt -Task $null } | Should throw "null"
                { Test-TodoTxt -Task "" } | Should throw "empty"
            }

            It "Passes testing for invalid parameters" {
                { $invalidTodoTxt | Test-TodoTxt -ErrorAction Stop } | Should throw "Cannot validate argument"
            }

            It "Passes testing for valid parameters" {
                $validTodoTxtArr | ForEach-Object {
                    $actual = $_ | Test-TodoTxt
                    $actual | Should BeOfType bool
                    $actual | Should Be $true
                }
            }
        }
    }
} #>