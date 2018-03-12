function Test-ObjectProperty {
    <#
    .SYNOPSIS
        Tests an oobject for a property.
    .DESCRIPTION
        Tests an object for the existence of a property.
    .NOTES
    Author: Paul Broadwith (https://github.com/pauby)
    .LINK
        https://www.github.com/pauby/pstodotxt
    .INPUTS
        [System.Object]
    .OUTPUTS
        [System.Boolean]
    .EXAMPLE
        (New-Object -TypeName PSObject -Property @{ test = "testing"} | Test-ObjectProperty -PropertyName "test"

        Tests the object passed on the pipeline for a property named 'test'. In this example the result is $true.
    #>

    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param
    (
        # The object to be tested
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [ValidateScript( { [bool]($_.GetType().Name -eq "PSCustomObject") } )]
        [ValidateNotNull()]
        [PSObject]$InputObject,

        # The property name of the object to be tested
        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$PropertyName
    )

    Begin {
        @('InputObject', 'PropertyName') | ForEach-Object {
            if (-not($PSBoundParameters.ContainsKey($_))) {
                throw [ArgumentException]"Mandatory parameter '$_' is missing."
            }
        }
    }

    Process {
        # check if the object has any properties to check NOTE: not entirely
        # sure we should be using [string]::IsNullOrEmpty() here but it works
        # whereas -eq $null doesn't
        if ([string]::IsNullOrEmpty($InputObject.PSObject.Properties)) {
            $false
        }
        else {
            [bool]($InputObject.PSobject.Properties.name -match $PropertyName)
        }

        # we should never get here
    }

    End	{
    }
}