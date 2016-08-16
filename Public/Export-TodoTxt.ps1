<#
.SYNOPSIS
    Imports todos from the todo file.
.DESCRIPTION
    Reads todos from the todo file and has them converted to todo objects before output.
.NOTES
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 29/04/16 - Initial version
.LINK
    https://www.github.com/pauby
.PARAMETER Path
    Path to the todo file.
.OUTPUTS
    Output is [array]
.EXAMPLE
    Import-Todo c:\todo.txt

    Reads the todos in the todo.txt file, has them converted to objects before outputting them..
#>

function Import-TodoTxt
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [object]
        $InputObject,

        [Parameter(Mandatory=$true)]
        [ValidateScript( { Test-Path $_ } )]
        [string]
        $Path,

        [switch]
        $Append
    )

    Begin {
        $todoText = @()
    }

    Process {
        $text = "{0}{1}{2}{3}{4}" -f { if ($InputObject.}
    }

    End {
    }
