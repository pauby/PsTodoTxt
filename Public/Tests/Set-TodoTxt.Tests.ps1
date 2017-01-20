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
    Context "Parameter Validation" -Tag 'ValidParams' {
  #      InModuleScope PSTodoTxt {

            Mock -ModuleName $ourModule Test-TodoTxtDate { return $false }

            It "will throw an exception for null or missing parameters" {
                { Set-TodoTxt -Todo $null } | Should throw "argument is null"
            }

            It "will throw an exception for invalid parameter data - invalid DoneDate" {
                { Set-TodoTxt -Todo (New-Object -TypeName PSObject) -DoneDate '2016-09-99'} | Should throw
                Assert-MockCalled -ModuleName $ourModule Test-TodoTxtDate -Times 1
            }

            It 'will pass for empty or $null data for parameters that accept it' {
                Set-TodoTxt -Todo (New-Object -TypeName PSObject) -DoneDate ''} | Should not throw
            }

  #      } # end InModuleScope
<#        $tests = @{ 'name'          = 'invalid DoneDate';
                    'parameters'    = @{ DoneDate = '2016-12-91' }
                 },
                 @{ 'name'          = 'empty CreatedDate'
                    'parameters'    = @{ CreatedDate = '' }
                 },
                 @{ 'name'          = 'invalid '

                 }


        It "will throw an exception for invalid input parameters" -TestCases $tests {
            Param (
                  $Para
            )
        }

        It "will pass for empty / new input object" {
            { Set-TodoTxt -Todo (New-Object -Typename PSObject) } | Should not throw
        }
    }

    Context "Processing and Logic" -Tag 'Proc' {
	# Processing and logic flow tests
    }

    Context "Output" -Tag 'Output' {
	# Output data tests
    }
#>
    Context "Code Analysis" -Tag 'CodeCheck' {
        if ($null -ne $functionScript) {
            if ($ExcludedPSSCriptAnalyserRules.Count -gt 0) {
                Write-Host "`nExcluded the following ScriptAnalyzer rules: `n    * $($ExcludedPSSCriptAnalyserRules -join '`n    * ')"
            }

            It 'passes all PSScriptAnalyser rules' {
                (Invoke-ScriptAnalyzer -Path $functionScript -ExcludeRule $ExcludedPSSCriptAnalyserRules).Count | Should Be 0
            }
        }
    }
}


<#
#Requires -Version 3.0

#if (-not $Variable:Function) {
    $Function = $PSScriptRoot.Split('.')[0]
#}
write-verbose "Function: $Function"

Describe "Testing Function - $($Function.Name) - Functional Processing & Logic" {
    InModuleScope PSTodoTxt {
        Context "Testing Mandatory Parameters Input" {
            It "Passes testing for null and missing mandatory parameter" {
                { Set-TodoTxt -Todo $null } | Should throw "argument is null"
                { Set-TodoTxt -Todo (New-Object -Typename PSObject) } | Should throw "Task property"
            }
                        
            It "Passes testing for valid mandatory parameter input" {
                $expected = New-Object -Typename PSObject -Property @{ Task = "Test task" }
                $actual = Set-TodoTxt -Todo (New-Object -Typename PSObject) -Task "Test task"
                Compare-Object -ReferenceObject $actual -DifferenceObject $expected -Property Task | Should Be $null
            }
        }

        Context "Testing Other Parameters Input" {
            It "Passes testing of invalid parameter input" {
                { (New-Object -TypeName PSObject) | Set-TodoTxt -CreatedDate "2016-99-99" -Task "Go see Jabba" } | Should throw "Cannot validate argument"
                { (New-Object -TypeName PSObject) | Set-TodoTxt -DoneDate "2016-99-99" -Task "Go see Jabba" } | Should throw "Cannot validate argument"
            }
        }

        Context "Valid data supplied" {
            $props1 = @{ CreatedDate = "2016-05-05"; DoneDate = "2016-09-09"; Priority = "H";
                Task = "Turn to the Dark Side"; Context = @("deathstar", "hoth"); 
                Project = @("rebelalliancedestruction", "deathstarbuild"); `
                Addon = @( @{due = "2016-10-01"}, @{ transport = "tie-fighter"} ) }
            $props2 = @{ CreatedDate = "2015-07-08"; DoneDate = "2016-01-01"; Priority = "D";
                Task = "Great, kid. Don't get cocky!"; Context = @("tatooine", "rebel-base"); 
                Project = @("death-star-blow-up"); `
                Addon = @( @{due = "2018-10-19"}, @{ transport = "milenium_falcon"} ) }
            $props3 = @{ CreatedDate = "2012-11-29"; Task = "I'm Luke Skywalker and I'm here to rescue you!"; 
                Context = @("Dagobah", "Mos-Eisley"); 
                Project = @("Yoda", "LearnTheForce"); `
                Addon = @( @{dead = "uncle-owen"}, @{ transport = "x-wing"} ) }

            It "Should return a valid TodoTxt object using the pipeline" {
                $expected = (New-Object -Typename PSObject -Property $props1)            
                $actual = (New-Object -Typename PSObject) | Set-TodoTxt -CreatedDate $props1.CreatedDate `
                    -DoneDate $props1.DoneDate -Priority $props1.Priority -Task $props1.Task -Context $props1.Context `
                    -Project $props1.Project -Addon $props1.Addon
                $actual | Should BeOfType Object
                Compare-Object -ReferenceObject $actual -DifferenceObject $expected `
                    -Property DoneDate, CreatedDate, Priority, Task, Context, Project, Addon | Should Be $null
            }

            It "Should return a valid TodoTxt object using the pipeline" {
                $expected = (New-Object -Typename PSObject -Property $props1)
                $actual = Set-TodoTxt -Todo (New-Object -Typename PSObject) -CreatedDate $props1.CreatedDate `
                    -DoneDate $props1.DoneDate -Priority $props1.Priority -Task $props1.Task -Context $props1.Context `
                    -Project $props1.Project -Addon $props1.Addon
                $actual | Should BeOfType Object
                Compare-Object -ReferenceObject $actual -DifferenceObject $expected `
                    -Property DoneDate, CreatedDate, Priority, Task, Context, Project, Addon | Should Be $null
            }

            It "Should amend the Task property of multiple existing TodoTxt objects using the pipeline" {
                $newTaskText = "Find a new song for the Cantina band"    
                $expected = @( (New-Object -TypeName PSObject -Property $props1), (New-Object -TypeName PSObject -Property $props2),
                    (New-Object -TypeName PSObject -Property $props3) )
                $expected | ForEach-Object { 
                    $_.Task = $newTaskText
                }                            
                $actual = @( (New-Object -TypeName PSObject -Property $props1), (New-Object -TypeName PSObject -Property $props2),
                    (New-Object -TypeName PSObject -Property $props3) )
                $actual = $actual | Set-TodoTxt -Task $newTaskText

                Write-Output -NoEnumerate $actual | Should BeOfType Array
                Compare-Object -ReferenceObject $actual -DifferenceObject $expected `
                    -Property DoneDate, CreatedDate, Priority, Task, Context, Project, Addon | Should Be $null
            }

            It "Should amend the Task property of multiple existing TodoTxt objects using Todo parameter" {
                $newTaskText = "Find a new song for the Cantina band"
                $expected = @( (New-Object -TypeName PSObject -Property $props1), (New-Object -TypeName PSObject -Property $props2),
                    (New-Object -TypeName PSObject -Property $props3) )
                $expected | ForEach-Object { 
                    $_.Task = $newTaskText
                }
         
                $actual = @( (New-Object -TypeName PSObject -Property $props1), (New-Object -TypeName PSObject -Property $props2),
                    (New-Object -TypeName PSObject -Property $props3) )
                $actual | ForEach-Object {
                    $_ = Set-TodoTxt -Todo $_ -Task $newTaskText
                }
                Write-Output -NoEnumerate $actual | Should BeOfType Array
                Compare-Object -ReferenceObject $actual -DifferenceObject $expected `
                    -Property DoneDate, CreatedDate, Priority, Task, Context, Project, Addon | Should Be $null
            }
        }
    }
}
#>