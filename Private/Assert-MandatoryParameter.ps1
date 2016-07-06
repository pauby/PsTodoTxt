<#
.SYNOPSIS
    Asserts the functions mandatory parameters.
.DESCRIPTION
    Check that the functions mandatory parameters have been passed to a function.
    Ordinarily functions use [Parameter(Mandatory=$true)] however this prompts
    for missing parameter values which may not be desired. This function allows
    you to declare what parameters are mandatory and ensure they have been passed.
.NOTES
	Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 06/07/16 - Initial version
.LINK
    https://www.github.com/pauby
.PARAMETER MandatoryParameter
    Mandatory parameter name.
.PARAMETER PassedParameter
    Parameter name passed to the function (this is normally just $PSBoundParameter
    from the caller).
.OUTPUTS
	The missing mandatory parameter names of type [string[]] or $null.
.EXAMPLE
    Assert-MandatoryParameter -MandatoryParameter @("Name", "Path") -PassedParameter $PSBoundParameter

    Checks that parameters 'Name' and 'Path' have both been passed to the calling function.
#>

function Assert-MandatoryParameter
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $MandatoryParameter,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [HashTable]
        $PassedParameter
    )

    # loop through each $PassedParameter and look for $MandatoryParameter
    # if it doesn't exist add it to a list
    $missingParameters = @()
    foreach ($parameter in $MandatoryParameter) {
        if (-not $PassedParameter.ContainsKey($parameter)) {
            $missingParameters += $parameter
        }
    }

    if ($missingParameters.count -gt 0) {
        return $missingParameters
    }

    return $null
}