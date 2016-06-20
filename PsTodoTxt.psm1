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
    'Get-TodoTxt.ps1',
    'Import-TodoTxt.ps1',
    'New-TodoTxtObject.ps1',    
    'Set-TodoTxt.ps1',
    'Split-TodoTxt.ps1',
    'Test-Functions.ps1',
    'Utility-Functions.ps1'
)

foreach ($script in $scriptsToLoad)
{
    Write-Verbose "Importing script file $script"
    . (Join-Path $PSScriptRoot $script)
}

#Export-ModuleMember -Function Use-Todo, Add-Todo, Remove-Todo, Set-Todo -Verbose:$VerbosePreference

#Set-Alias t Use-Todo -Verbose:$VerbosePreference
#Export-ModuleMember -Alias t -Verbose:$VerbosePreference