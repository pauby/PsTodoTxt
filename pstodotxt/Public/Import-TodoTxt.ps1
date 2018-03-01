function Import-TodoTxt
{
<#
.SYNOPSIS
    Imports todotxt strings and converts them to objects.
.DESCRIPTION
    Imports todotxt strings from the source file and converts them to objects.
.NOTES
    Author: Paul Broadwith (https://github.com/pauby)
.LINK
    https://www.github.com/pauby/pstodotxt
.OUTPUTS
    System.Object
.EXAMPLE
    Import-Todo -Path c:\todo.txt

    Reads the todotxt strings from the file c:\todo.txt and converts them to objects.
#>

    [CmdletBinding()]
    [OutputType([System.Object])]
    Param (
        # Path to the todo file. The file must exist. Throws an exception if the
        # file does not exist. Nothing is returned if file is empty.
        [Parameter(Mandatory=$true)]
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
        $todos | Where-Object { -not [string]::ISNullOrEmpty($_) } | ConvertTo-TodoTxt
    }
}