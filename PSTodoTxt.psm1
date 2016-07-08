<#
.NOTES
    File Name	: PoshTodo.psm1
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 09/10/15 - Initial version

    TODO        :
#>
#Requires -Version 3
Set-StrictMode -Version Latest


$scriptsToLoad = @(
    'Public\Get-TodoTxt.ps1',
    'Public\Import-TodoTxt.ps1',
    'Public\Split-TodoTxt.ps1',
    'Public\Set-TodoTxt.ps1',
    'Private\New-TodoTxtObject.ps1',
    'Private\Test-ObjectProperty.ps1',
    'Private\Test-Functions.ps1',
    'Private\Utility-Functions.ps1'
    'Private\Assert-MandatoryParameter.ps1'
)

foreach ($script in $scriptsToLoad)
{
    Write-Verbose "Importing script file $script"
    . (Join-Path $PSScriptRoot $script)
}