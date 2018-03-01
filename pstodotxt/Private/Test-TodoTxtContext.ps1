function Test-TodoTxtContext
{
<#
.SYNOPSIS
    Tests the todo context.
.DESCRIPTION
    Test the todo context is in the correct format.
.NOTES
    Author: Paul Broadwith (https://github.com/pauby)

    TODO        : The function should only test a single context string so we know which one if any fail.
                  At the moment if any of the contexts fail we fail the whole test.
.LINK
    https://www.github.com/pauby/pstodotxt
.OUTPUTS
    [System.Boolean]
.EXAMPLE
    Test-TodoContext "@computer","@home"

    Tests to see if the contexts "@computer" and "@home" are valid and returns $true or $false.
#>

    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param (
        # The context(s) to test. A valid context is a string contains no
        # whitespace and starting with an '@'
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Project")]
        [string[]]$Context
    )

    # Context / Project / Tag / List should be a string (or an array of strings)
    $regex = [regex]"^[a-zA-z\d-_]+$"

    foreach ($item in $Context) {
        if (($regex.Match($item)).Success -ne $true) {
            $false
        }
        else {
            $true
        }
    }
}