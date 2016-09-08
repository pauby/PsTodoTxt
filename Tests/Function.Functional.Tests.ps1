$projRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

$ModuleFunctions = @(Get-ChildItem "$projRoot\Public\" -Filter '*.ps1' -Recurse | Where-Object {$_.name -NotMatch "Tests.ps1"})
$ModuleFunctions += Get-ChildItem "$projRoot\Private\" -Filter '*.ps1' -Recurse | Where-Object {$_.name -NotMatch "Tests.ps1"}

$ModuleFunctionTests = @(Get-ChildItem "$projRoot\Public\" -Filter '*Tests.ps1' -Recurse)
$ModuleFunctionTests += Get-ChildItem "$projRoot\Private\" -Filter '*Tests.ps1' -Recurse

$ExcludedRules = @("PSUseShouldProcessForStateChangingFunctions")
$Rules = Get-ScriptAnalyzerRule | Where { $_.Rulename -notin $ExcludedRules }

$manifest = Get-Item "$projRoot\*.psd1"
$module = $manifest.BaseName
Remove-Module PSTodoTxt
Import-Module "$projRoot\$($module).psd1"

$ModuleData = Get-Module $Module
$AllFunctions = & $moduleData {Param($modulename) Get-command -CommandType Function -Module $modulename} $module

if ($ModuleFunctions.count -gt 0) {
    foreach($ModuleFunction in $ModuleFunctions)
    {
        Describe "Testing Private Function - $($ModuleFunction.BaseName) - Standard Processing" {
            It "Is valid Powershell (Has no script errors)" {
                $contents = Get-Content -Path $PrivateFunction.FullName -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
                $errors.Count | Should Be 0
            }

            foreach ($rule in $rules) {
                It "passes the PSScriptAnalyzer Rule $rule" {
                    (Invoke-ScriptAnalyzer -Path $PrivateFunction.FullName -IncludeRule $rule.RuleName ).Count | Should Be 0
                }
            }

            It 'Passes all Script Analyzer tests' {
                (Invoke-ScriptAnalyzer -Path $ModuleFunction.FullName -ExcludeRule $ExcludedRules ).Count | Should Be 0
            }
        }

        $function = $AllFunctions.Where{ $_.Name -eq $ModuleFunction.BaseName}
        $FunctionTests = $ModuleFunctionTests.Where{$_.Name -match $function.Name }
        foreach ($Test in $FunctionTests) {
            . $($Test.FullName) $function
        }
    }
}