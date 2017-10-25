#Requires -Module Pester

. "$PSScriptRoot\..\shared-module-pstodotxt.ps1"

$scriptType = Split-Path $PSScriptRoot -Leaf | Where-Object { $_ -in @("private", "public") }
$scriptFilename = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$scriptPath = "$root\source\$(Join-Path -Path $scriptType -ChildPath $scriptFilename)"

"{0,-15} : {1}" -f "Script Filename", $scriptFilename | Write-Verbose
"{0,-15} : {1}" -f "Script Type", $scriptType | Write-Verbose
"{0,-15} : {1}" -f "Script Path", $scriptPath | Write-Verbose

Describe "Function Testing - ConvertTo-TodoTxt" {
    Context "Parameter Validation" {
        It "will throw an exception for null or missing parameters" {
            # we only have one parameter so test it
            { ConvertTo-TodoTxt -Todo $null } | Should throw "null or empty"
            { ConvertTo-TodoTxt -Todo (New-Object -Typename PSObject) } | Should throw "null or empty"
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
                $result = $todo | ConvertTo-TodoTxt
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

                { ConvertTo-TodoTxt -Todo $todo } | Should throw
            }
        } # end InModuleScope
    }

    if (!(Test-Path $scriptPath)) {
        Write-Error "Cannot find the script $scriptPath. Will not check the code quality with PSScriptAnalyser."
    }
    else {
        Context "Code Analysis" {

            It 'passes all PSScriptAnalyser rules' {
                    (Invoke-ScriptAnalyzer -Path $scriptPath).count | Should Be 0
            }
        }
    }
}