<#
.SYNOPSIS
    Tests a date.
.DESCRIPTION
    Tests a date for the format yyy-MM-dd. It does not test to see if the date is in the future, past or present.
.NOTES
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 28/09/15 - Initial version
    TODO        : Might be easier to this via a regular expression.
.LINK
    https://www.github.com/pauby
.PARAMETER Date
    The date to test. Note that this is a string and not a date object.
.OUTPUTS
	Whether the date is valid or not. Output type is [bool]
.EXAMPLE
    Test-TodoDate -TestDate '2015-10-10'

    Tests to ensure the date '2015-10-10' is in the valid todo date format and outputs $true or $false.
#>
function Test-TodoTxtDate
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Date
    )

    # what we do here is first of all pass the date to Get-Date and ask it to format it in yyyy-MM-dd.
    # If it doesn't output the same as the input the date is not in a valid format.
    # also make sure we don't display errors if there is invalid input; instead return $false
    $error.Clear()
    try {
        $result = Get-Date $Date -Format "yyyy-MM-dd" -ErrorAction SilentlyContinue
    }
    catch [System.Exception] {
        return $false
    }

    if ($result.CompareTo($Date) -ne 0 -or $? -eq $false) # test if the date returned is not the same as the input or we have an error
    {
        $false
    }
    else
    {
        $true
    }
}