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
        Mock -ModuleName $ourModule Test-TodoTxtDate { return $false }
        Mock -ModuleName $ourModule Test-TodoTxtPriority { return $false }
        Mock -ModuleName $ourModule Test-TodoTxtContext { return $false }

        It "will throw an exception for null, empty or missing parameters" {
            { Set-TodoTxt -Todo $null } | Should throw "argument is null"
            { Set-TodoTxt -Todo (New-Object -TypeName PSObject) -CreatedDate '' } | Should throw "argument is null"
            { Set-TodoTxt -Todo (New-Object -TypeName PSObject) -Task '' } | Should throw "argument is null"
        }

        # remember we are testing that the ValidateScript scriptblock is being executed - we don't care about the results.
        $tests = @(
            @{  'name'      = 'DoneDate';
                'splat'     = @{ 'donedate' = '2016-01-99' };
                'function'  = 'Test-TodoTxtDate'
            },
            @{  'name'      = 'CreatedDate';
                'splat'     = @{ 'createddate' = '2016-01-99' };
                'function'  = 'Test-TodoTxtDate'
            },
            @{  'name'      = 'Priority';
                'splat'     = @{ 'priority' = '1' };
                'function'  = 'Test-TodoTxtPriority'
            },
            @{  'name'      = 'Context';
                'splat'     = @{ 'context' = 'here' };
                'function'  = 'Test-TodoTxtContext'
            },
            @{  'name'      = 'Project';
                'splat'     = @{ 'project' = 'here' };
                'function'  = 'Test-TodoTxtContext'
            }
            )

        It "will throw an exception in ValidateScript statement - <name>" -TestCases $tests {
            Param (
                $splat,
                $function
            )

            { Set-TodoTxt -Todo (New-Object -TypeName PSObject) @splat } | Should throw "did not return a result of True"
            Assert-MockCalled -ModuleName $ourModule -CommandName $function -Times 1
        }

        It 'will pass for empty or $null data for parameters that accept it' {
            { Set-TodoTxt -Todo (New-Object -TypeName PSObject) -DoneDate ''} | Should not throw
            { Set-TodoTxt -Todo (New-Object -TypeName PSObject) -Priority ''} | Should not throw
            { Set-TodoTxt -Todo (New-Object -TypeName PSObject) -Context ''} | Should not throw
            { Set-TodoTxt -Todo (New-Object -TypeName PSObject) -Project ''} | Should not throw
        }
    }

    Context "Processing and Logic" -Tag 'Proc' {
	# Processing and logic flow tests
    }

    Context "Output" -Tag 'Output' {
        $props1 = @{ CreatedDate = "2016-05-05"; DoneDate = "2016-09-09"; Priority = "H";
            Task = "Turn to the Dark Side"; Context = @("deathstar", "hoth");
            Project = @("rebelalliancedestruction", "deathstarbuild"); `
            Addon = @( @{due = "2016-10-01"}, @{ transport = "tie-fighter"} )
            }

        # the same code is used to set any property so we only need to test 1 of removing and 1 of changing

        It 'will pass removing an object property' {
            $objTest = New-Object -TypeName PSObject -Property $props1
            $result = Set-TodoTxt -Todo $objTest -DoneDate ''

            $result | Should BeOfType PSObject
            $result.PSObject.Properties.Name.Count | Should be ($props1.Count - 1)
        }

        It 'will pass modifying a property value' {
            $objTest = New-Object -TypeName PSObject -Property $props1
            $result = Set-TodoTxt -Todo $objTest -Priority 'Z'
            $result.Priority | Should be 'Z'
        }
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