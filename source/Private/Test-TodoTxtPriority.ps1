<#
.SYNOPSIS
    Tests a todo priority.
.DESCRIPTION
    Tests to ensure that the priority is valid.
.NOTES
    Author: Paul Broadwith (https://github.com/pauby)
    TODO: Might be easier to this via a regular expression.
.LINK
    https://www.github.com/pauby/pstodotxt
.OUTPUTS
	[System.Boolean]
.EXAMPLE
    Test-TodoPriority "N"

    Tests to see if the priority "N" is valid and outputs $true or $false.
#>
function Test-TodoTxtPriority
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param (
        # The priority to test. A valid priority is a single character string that is between A and Z.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Priority
    )

    # ensure priority is one character long, is a letter between A and Z
    $Priority = $Priority.ToUpper()
    ($Priority.CompareTo("A") -ge 0) -and ($Priority.CompareTo("Z") -le 0) -and ($Priority.Length -eq 1)
}