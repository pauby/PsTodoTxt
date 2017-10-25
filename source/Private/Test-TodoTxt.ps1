function Test-TodoTxt
{
<#
.SYNOPSIS
    Tests a todotxt object.
.DESCRIPTION
    Tests a TodoTxt object properties to ensure they conform to the todotxt specification.
.NOTES
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 15/09/16 - Initial version
                  1.1 - 23/01/17 - Refactored code
.LINK
    https://www.github.com/pauby/pstodotxt
.PARAMETER DoneDate
    The DoneDate property to test.
.PARAMETER CreatedDate
    The CreatedDate property to test.
.PARAMETER Priority
    The Priority property to test.
.PARAMETER Task
    The Tasks property to test.
.PARAMETER Context
    The Context property to test.
.PARAMETER Project
    The Project property to test.
.PARAMETER Addon
    The Addon (key:value pairs) property to test.
.OUTPUTS
	Result of the tested todo - true or false [boolean]
.EXAMPLE
    $obj | Test-TodoTxt

    Tests the properties of the object $obj.
#>

    [CmdletBinding()]
    [OutputType([boolean])]
	Param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias("dd")]
        [string]$DoneDate,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias("cd")]
        [string]$CreatedDate,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias("pri", "u")]
        [string]$Priority,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias("t")]
        [string]$Task,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias("c")]
        [string[]]$Context,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias("p")]
        [string[]]$Project,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias("a")]
        [string[]]$Addon
    )

    Process
    {
        # we didn't mark any parameters mandatory as we didn't want to prompt for them but throw instead
        # test mandatory parameters here
        $mandatoryParams = @( 'CreatedDate', 'Task')
        $keys = @($PsBoundParameters.Keys | Where-Object { $_ -in $mandatoryParams })
        if ($keys.count -ne $mandatoryParams.count) {
            return $false
        }

        # test each parameter passed
        foreach ($key in $PsBoundParameters.Keys) {
            switch ($key) {
                { $_ -in @('DoneDate', 'CreatedDate') } {
                    if (-not (Test-TodoTxtDate $PsBoundParameters.$key)) {
                        return $false
                    }
                    break
                }

                "Priority" {
                    if (-not (Test-TodoTxtPriority $PSBoundParameters.$key)) {
                        return $false
                    }
                    break
                }

                "Task" {
                    if ([string]::IsNullOrEmpty($PSBoundParameters.$key)) {
                        return $false
                    }
                    break
                }

                { $_ -in @( 'Context', 'Project') } {
                    if (-not (Test-TodoTxtContext $PSBoundParameters.$key)) {
                        return $false
                    }
                }
            } #end switch
        } #end foreach

        # if we get here we have passed all Tests
        $true
    } #end process
}