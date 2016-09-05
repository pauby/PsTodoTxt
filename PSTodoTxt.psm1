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
    'Public\Import-TodoTxt.ps1',
    'Public\Expor'
    'Public\ConvertFrom-TodoTxtString.ps1',
    'Public\Set-TodoTxt.ps1',
    'Public\ConvertTo-TodoTxtString.ps1',
    'Private\Assert-MandatoryParameter.ps1',
    'Private\Get-TodoTxtTodaysDate.ps1',
    'Private\New-TodoTxtObject.ps1',
    'Private\Test-ObjectProperty.ps1',
    'Private\Test-TodoTxtContext.ps1',
    'Private\Test-TodoTxtDate.ps1',
    'Private\Test-TodoTxtPriority.ps1',
    'Private\Write-VerboseHashTable.ps1'
)

$toInclude = @()                            # add the files, in the root, to be included
$searchFolders = @('Public', 'Private')     # add the folders, from the root, that are to be searched for .ps1 files 
$searchFolders | ForEach-Object { 
        $toInclude += (Get-ChildItem (Join-Path -Path $PSScriptRoot -ChildPath $_) -recurse -include '*.ps1')
}

foreach ($script in $toInclude) {
    Write-Verbose "Importing $script"
    . $script
}

New-Alias -Name Test-TodoTxtProject -Value Test-TodoTxtContext