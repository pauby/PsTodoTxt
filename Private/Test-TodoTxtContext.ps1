<#
.SYNOPSIS
    Tests the todo context.
.DESCRIPTION
    Test the todo context is in the correct format.
.NOTES
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 28/09/15 - Initial version

    A valid context is a string contains no whitespace and starting with an '@'

    TODO        : The function should only test a single context string so we know which one if any fail.
                  At the moment if any of the contexts fail we fail the whole test.
.LINK
    https://www.github.com/pauby/
.PARAMETER Context
    The context(s) to test.
.OUTPUTS
	Whether the context(s) are valid or not. Output type is [bool]
.EXAMPLE
    Test-TodoContext "@computer","@home"

    Tests to see if the contexts "@computer" and "@home" are valid and returns $true or $false.
#>
function Test-TodoTxtContext
{
    [CmdletBinding()]
    [OutputType([bool])]
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Alias("Project")]
        [string[]]$Context
    )

    # Context, as stored in the object, should just be a word with no spaces and not start with an @
    # this regex is to match whitespace or an @ - if they match anything then the context is invalid
    $regex = [regex]"[@+\s]"

    $Context | foreach-Object {
        if (($regex.Match($_)).Success -eq $True) {
            return $false
        }
    }

    # if we get here each context must be valid
    $true
}