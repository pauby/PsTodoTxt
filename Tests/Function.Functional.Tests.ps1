$projRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

$PrivateFunctions = Get-ChildItem "$projRoot\Private\" -Filter '*.ps1' -Recurse | Where-Object {$_.name -NotMatch "Tests.ps1"}
$PublicFunctions = Get-ChildItem "$projRoot\Public\" -Filter '*.ps1' -Recurse | Where-Object {$_.name -NotMatch "Tests.ps1"}

$PrivateFunctionsTests = Get-ChildItem "$projRoot\Private\" -Filter '*Tests.ps1' -Recurse
$PublicFunctionsTests = Get-ChildItem "$projRoot\Public\" -Filter '*Tests.ps1' -Recurse

$ExcludedRules = @("PSUseShouldProcessForStateChangingFunctions")
$Rules = Get-ScriptAnalyzerRule | Where { $_.Rulename -notin $ExcludedRules }

$manifest = Get-Item "$projRoot\*.psd1"
$module = $manifest.BaseName
Import-Module "$projRoot\$($module).psd1" -Global

$ModuleData = Get-Module $Module
$AllFunctions = & $moduleData {Param($modulename) Get-command -CommandType Function -Module $modulename} $module

if ($PrivateFunctions.count -gt 0) {
    foreach($PrivateFunction in $PrivateFunctions)
    {
        Describe "Testing Private Function - $($PrivateFunction.BaseName) - for Standard Processing" {
<#            It "Is valid Powershell (Has no script errors)" {
                $contents = Get-Content -Path $PrivateFunction.FullName -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
                $errors.Count | Should Be 0
            }

            foreach ($rule in $rules) {
                It "passes the PSScriptAnalyzer Rule $rule" {
                    (Invoke-ScriptAnalyzer -Path $PrivateFunction.FullName -IncludeRule $rule.RuleName ).Count | Should Be 0
                }
            }#>
        }

        Write-Host "AllFunctions = $AllFunctions"
        $function = $AllFunctions.Where{ $_.Name -eq $PrivateFunction.BaseName}
        Write-Host "Function: $($function.basename)"
        $PrivateFunctionTests = $PrivateFunctionsTests.Where{$_.Name -match $Function.Name }
        Write-Host "PrivateFunctionTests: $PrivateFunctionTests"
        foreach ($PrivateFunctionTest in $PrivateFunctionTests) {
            . $($PrivateFunctionTest.FullName) $function
        }
    }
}


if ($PublicFunctions.count -gt 0) {

    foreach($PublicFunction in $PublicFunctions)
    {

    Describe "Testing Public Function  - $($PublicFunction.BaseName) for Standard Processing" {

          It "Is valid Powershell (Has no script errors)" {

                $contents = Get-Content -Path $PublicFunction.FullName -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
                $errors.Count | Should Be 0
            }
      foreach ($rule in $rules) {

                    It "passes the PSScriptAnalyzer Rule $rule" {

                        (Invoke-ScriptAnalyzer -Path $PublicFunction.FullName -IncludeRule $rule.RuleName ).Count | Should Be 0

                        }
                    }

            }

            $function = $AllFunctions.Where{ $_.Name -eq $PublicFunction.BaseName}
            $publicfunctionTests = $Publicfunctionstests.Where{$_.Name -match $Function.Name }

            foreach ($publicfunctionTest in $publicfunctionTests) {
                . $($PublicFunctionTest.FullName) $function
                }
       }
}