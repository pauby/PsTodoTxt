<#
.NOTES
    File Name	: PoshTodo.psm1
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 09/10/15 - Initial version

    TODO        :
#>
#Requires -Version 3
Set-StrictMode -Version Latest

$toInclude = @()                            # add the files, in the root, to be included
$searchFolders = @('Public', 'Private')     # add the folders, from the root, that are to be searched for .ps1 files
$searchFolders | ForEach-Object {
        $toInclude += (Get-ChildItem (Join-Path -Path $PSScriptRoot -ChildPath $_) -recurse -include '*.ps1' -Exclude '*.Tests.ps1')
}

foreach ($script in $toInclude) {
    Write-Verbose "Importing $script"
    . $script
}