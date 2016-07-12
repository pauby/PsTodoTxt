<#
.SYNOPSIS
    Tests a todo priority.
.DESCRIPTION
    Tests to ensure that the priority is valid.
.NOTES
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 28/09/15 - Initial version

    A valid priority is a single character string that is between A and Z.

    TODO        : Might be easier to this via a regular expression.
.LINK
    https://www.github.com/pauby/
.PARAMETER Priority
    The priority to test.
.OUTPUTS
	Whether the priority is correct. Output type is [bool]
.EXAMPLE
    Test-TodoPriority "N"

    Tests to see if the priority "N" is valid and outputs $true or $false.
#>
function Test-TodoTxtPriority
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Priority
    )

    # ensure priority is one character long, is a letter between A and Z
    $Priority = $Priority.ToUpper()
    ($Priority.CompareTo("A") -ge 0) -and ($Priority.CompareTo("Z") -le 0) -and ($Priority.Length -eq 1)
}