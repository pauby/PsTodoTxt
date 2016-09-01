<#
.SYNOPSIS
    Tests an oobject for a property.
.DESCRIPTION
    Tests an object for the existence of a property.
.NOTES
	Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 26/04/16 - Initial version
				  1.1 - 01/09/16 - Added ValidateScript to check that input is an object
	Credit		: Code originally taken from http://stackoverflow.com/questions/26997511/how-can-you-test-if-an-object-has-a-specific-property (author http://stackoverflow.com/users/520612/cb)
	Notes		: Code requires PowerShell v3 - see Credit link for v2 version
#Requires -Version 3
.LINK
    https://www.github.com/pauby
.PARAMETER InputObject
    (MANDATORY) The object to be tested.
.PARAMETER PropertyName
	The property name of the object to be tested.
.INPUTS
	The object to be tested. Is of type [psobject]
.OUTPUTS
	Whether the property exists or not. Is of type [boolean]
.EXAMPLE
    (New-Object -TypeName PSObject -Property @{ test = "testing"} | Test-ObjectProperty -PropertyName "test"

    Tests the object passed on the pipeline for a property named 'test'. In this example the result is $true.
#>

function Test-ObjectProperty
{
	[CmdletBinding()]
	[OutputType([boolean])]
	Param
	(
		[Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
		[ValidateScript( { $_.GetType().Name -eq "PSCustomObject" } )]
		[ValidateNotNull()]
		[object]$InputObject,

		[Parameter(Mandatory=$true, Position=1)]
		[ValidateNotNullOrEmpty()]
		[string]$PropertyName
	)

	Begin {
	}

	Process	{
        # check if the object has any properties to check
        # NOTE: not entirely sure we should be using [string]::IsNullOrEmpty() here but it works whereas -eq $null doesn't
        if ([string]::IsNullOrEmpty($InputObject.PSObject.Properties)) {
            return $false
        }
        else {
            return [bool]($InputObject.PSobject.Properties.name -match $PropertyName)
        }

		# we should never get here
	}

	End	{
	}
}