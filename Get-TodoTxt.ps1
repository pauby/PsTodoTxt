<#
.NOTES
	File Name	: PoshTodo.psm1
	Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 29/04/16 - Initial version

    TODO        :
#>

<#
.SYNOPSIS
    Short description.
.DESCRIPTION
    Long description.
.NOTES
	Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 29/04/16 - Initial version
.LINK
    https://www.github.com/pauby
.PARAMETER PARAMETER
    Parameter description
.INPUTS
	Parameter and type [psobject]
.OUTPUTS
	Output and type [psobject]
.EXAMPLE
    $todoObj = $todoObj | Set-Todo -Priority "B"

    Sets the priority of the $todoObj to "B" and outputs the modified todo.
#>

function Get-TodoTxt
{
    [CmdletBinding()]
    Param 
    (
        [Parameter(Mandatory=$true,
                    HelpMessage="Enter path to todotxt file.")]
        [ValidateScript( { Test-Path $_ } )]
        [string]$Path
    )
    
    Import-TodoTxt -Path $Path | ConvertTo-TodoTxtObject
     
    #@($a | ConvertTo-TodoTxtObject)
}