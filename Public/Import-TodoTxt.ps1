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
    [OutputType([array])]
    Param (
        [Parameter(Mandatory=$true, 
                   HelpMessage='Enter the path to the todotxt file.')]
        [ValidateScript( { Test-Path $_ } )]
        [string]$Path
    )

    # Read the contents of the todo file and force it's output to be an array so we can check number returned.
    $todoList = @()
    
    Write-Verbose "Reading todo file ($Path) contents."
    $todos = Get-Content -Path $Path -Encoding UTF8
    if ($todos -eq $null) {
        Write-Verbose "File $Path is empty."
    }
    else {
        Write-Verbose "Read $($todos.count) todos."
        Write-Verbose "Splitting todos into properties"
        $splitTodos = $todos | Split-TodoTxt
    
        foreach ($todo in $splitTodos) {
            $todoList += New-Object -TypeName PSObject -Property $todo 
        }
    }

    # if there are no todos read then this will return an empty list
    ,$todoList
}