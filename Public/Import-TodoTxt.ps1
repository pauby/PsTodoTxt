function Import-TodoTxt
{
<#
.SYNOPSIS
    Imports todotxt strings and converts them to objects.
.DESCRIPTION
    Imports todotxt strings from the source file and converts them to objects.
.NOTES
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 29/04/16 - Initial version.
                : 1.1 - 06/09/16 - Removed forcing output to be an array and replaced return with Write-Output.
.LINK
    https://www.github.com/pauby/pstodotxt
.PARAMETER Path
    Path to the todo file. The file must exist.
    Throws an exception if the file does not exist. Nothing is returned if file is empty.
.OUTPUTS
    Output is [object]
.EXAMPLE
    Import-Todo -Path c:\todo.txt

    Reads the todotxt strings from the file c:\todo.txt and converts them to objects.
#>
    [CmdletBinding()]
    [OutputType([object])]
    Param (
        [Parameter(Mandatory=$true,
                   HelpMessage='Enter the path to the todotxt file.')]
        [ValidateScript( { Test-Path $_ } )]
        [string]$Path
    )

    Write-Verbose "Reading todo file ($Path) contents."
    $todos = Get-Content -Path $Path -Encoding UTF8
    if ($null -eq $todos) {
        Write-Verbose "File $Path is empty."
    }
    else {
        Write-Verbose "Read $(@($todos).count) todos."
        Write-Output $todos | ConvertTo-TodoTxt
    }
}