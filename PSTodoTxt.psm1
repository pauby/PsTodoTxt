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
    'Public\ConvertFrom-TodoTxtString.ps1',
    'Public\Set-TodoTxt.ps1',
    'Public\Join-Todotxt.ps1',
    'Private\Assert-MandatoryParameter.ps1',
    'Private\Get-TodoTxtTodaysDate.ps1',
    'Private\New-TodoTxtObject.ps1',
    'Private\Test-ObjectProperty.ps1',
    'Private\Test-TodoTxtContext.ps1',
    'Private\Test-TodoTxtDate.ps1',
    'Private\Test-TodoTxtPriority.ps1',
    'Private\Write-VerboseHashTable.ps1'
)

foreach ($script in $scriptsToLoad)
{
    Write-Verbose "Importing script file $script"
    . (Join-Path $PSScriptRoot $script)
}

New-Alias -Name Test-TodoTxtProject -Value Test-TodoTxtContext