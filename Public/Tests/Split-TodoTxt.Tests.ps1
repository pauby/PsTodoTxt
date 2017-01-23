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
    Context "Parameter Validation" {
        It "will throw an exception for null or missing parameters" {
            # we only have one parameter so test it
            { Split-TodoTxt -Todo $null } | Should throw "null or empty"
            { Split-TodoTxt -Todo (New-Object -Typename PSObject) } | Should throw "null or empty"
        }
    }

    Context "Processing and Logic" {
    }

    Context "Output" {
        InModuleScope PsTodoTxt {
            $todaysDate = "2016-01-01"
            Mock Get-TodoTxtTodaysDate { return $todaysDate }

            $validTests = @(
                @{  "name"      = "one of each component";
                    "todo"      = "x 2016-12-11 (r) 2016-10-09 Go to Ewok planet @home +travel due:2016-12-03";
                    "expected"  = (New-Object -TypeName PSObject -Property @{ DoneDate = "2016-12-11"; Priority = "R"; CreatedDate="2016-10-09";
                                    Context = @( "home" ); Project = @( "travel" ); Addon = @{ "due" = "2016-12-03" }; Task = "Go to Ewok planet" })
                },
                @{  "name"      = "just task";
                    "todo"      = "Go to Ewok planet";
                    "expected"  = (New-Object -TypeName PSObject -Property @{ CreatedDate = $todaysDate; Task = "Go to Ewok planet"} )
                },
                @{  "name"      = "double @@ / ++ for context / project"
                    "todo"      = "x 2016-01-23 Go to Ewok planet @@deathstar ++ewok";
                    "expected"  = (New-Object -TypeName PSObject -Property @{ DoneDate = "2016-01-23"; CreatedDate = $todaysDate; Task = "Go to Ewok planet @@deathstar ++ewok"} )
                },
                @{  "name"      = "no task text";
                    "todo"      = "2016-12-09 @deathstar +ewok";
                    "expected"  = (New-Object -TypeName PSObject -Property @{ CreatedDate = "2016-12-09"; Task = "@deathstar +ewok"} )
                }
            )

            It "outputs the correct todo object when valid todo string is passed - <name>" -TestCases $validTests {
                Param (
                    $todo,
                    $expected
                )
                $result = $todo | Split-TodoTxt
                Compare-Object -ReferenceObject $expected -DifferenceObject $result | Should be $null
            }

            $invalidTests = @(
                @{  "name"      = "invalid created date";
                    "todo"      = "2016-10-99 Go to Ewok planet"
                },
                @{  "name"      = "invalid done date";
                    "todo"      = "x 2016-88-10 Go to Ewok planet @deathstar";
                },
                @{  "name"      = "different date format";
                    "todo"      = "2016-23-01 Go to Ewok planet";
                }
            )

            It "throws an exception with invalid todo string - <name>" -TestCases $invalidTests {
                Param (
                    $todo
                )

                { Split-TodoTxt -Todo $todo } | Should throw
            }
        } # end InModuleScope
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