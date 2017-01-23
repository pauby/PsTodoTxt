#Requires -Module Pester

$ourModule = 'PSTodoTxt'
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

Write-Host "`nFunction Testing - $($functionName)" -ForegroundColor Magenta
Describe 'Test parameter validation' -Tag 'testparam' {

    It 'will throw an exception for null or missing parameters' {
        { Join-TodoTxt -Todo $null } | Should throw 'argument is null'  # use parameter instead of pipeline otherwise exception not caught
    }
}

Describe 'Test internal function processing, logic and flow' -Tag 'flow' {
    InModuleScope $ourModule {

        Mock Test-TodoTxt { return $false }

        It 'will throw an exception for an invalid object' {
            { (New-Object -TypeName PSObject -Property @{ 'task' = 'This will fail' }) | Join-TodoTxt } | SHould throw 'invalid Todotxt object'
        }
    }
}

Describe "Test and validate output" -tag 'output' {

    $tests = @(
        @{  'name'          = 'with DoneDate, CreatedDate and Task';
            'testObject'    = (New-Object -TypeName PSObject -Property @{ 'DoneDate' = '2019-01-12'; 'CreatedDate' = '2016-01-01'; 'Task' = 'Rescue Han from Jabba' });
            'result'        = 'x 2019-01-12 2016-01-01 Rescue Han from Jabba'
        },
        @{  'name'          = 'with Priority, CreatedDate and Task';
            'testObject'    = (New-Object -TypeName PSObject -Property @{ 'Priority' = 'G'; 'CreatedDate' = '2016-01-01'; 'Task' = 'Rescue Han from Jabba' });
            'result'        = '(G) 2016-01-01 Rescue Han from Jabba'
        },
        @{  'name'          = 'with CreatedDate, Task and Context';
            'testObject'    = (New-Object -TypeName PSObject -Property @{ 'Context' = @('palace', 'jabba'); 'CreatedDate' = '2016-01-01'; 'Task' = 'Rescue Han from Jabba' });
            'result'        = '2016-01-01 Rescue Han from Jabba @palace @jabba'
        },
        @{  'name'          = 'with CreatedDate, Task and Addon';
            'testObject'    = (New-Object -TypeName PSObject -Property @{ 'Addon' = @{ 'due' = '2017-09-01'; 'help' = 'leia'}; 'CreatedDate' = '2016-01-01';
                'Task' = 'Rescue Han from Jabba' });
            'result'        = '2016-01-01 Rescue Han from Jabba due:2017-09-01 help:leia'
        },
        @{  'name'          = 'with everything';
            'testObject'    = (New-Object -TypeName PSObject -Property @{ 'DoneDate' = '2018-08-15'; Priority = 'K'; 'CreatedDate' = '2016-01-01';
            'Task' = 'Rescue Han from Jabba'; 'Context' = @('palace', 'jabba'); 'Project' = @('rescue', 'rescue-han'); 'Addon' = @{ 'due' = '2087-12-09'; 'help' = 'luke'} });
            'result'        = 'x 2018-08-15 (K) 2016-01-01 Rescue Han from Jabba @palace @jabba +rescue +rescue-han due:2087-12-09 help:luke'
        }
    )

    It "will return a joined string - <name>" -TestCases $tests {
        Param (
            $testObject, $result
        )

        ($testObject | Join-TodoTxt) | Should Be $result
        Join-TodoTxt -Todo $testObject | Should be $result
    }
}

Describe "Code analysis" -Tag 'codecheck' {
    if ($null -ne $functionScript) {
        if ($ExcludedPSSCriptAnalyserRules.Count -gt 0) {
            Write-Host "`nExcluded the following ScriptAnalyzer rules: `n    * $($ExcludedPSSCriptAnalyserRules -join '`n    * ')`n"
        }

        It 'passes all PSScriptAnalyser rules' {
            (Invoke-ScriptAnalyzer -Path $functionScript -ExcludeRule $ExcludedPSSCriptAnalyserRules).Count | Should Be 0
        }
    }
}

Write-Host "`nEnd Function Testing" -ForegroundColor Magenta