function Test-TodoTxt {
<#
.SYNOPSIS
    Tests a todotxt object.
.DESCRIPTION
    Tests a TodoTxt object properties to ensure they conform to the todotxt
    specification.
.NOTES
    Author: Paul Broadwith (https://github.com/pauby)
.LINK
    https://www.github.com/pauby/pstodotxt
.OUTPUTS
    [System.Boolean]
.EXAMPLE
    $obj | Test-TodoTxt

    Tests the properties of the object $obj.
#>

    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param(
        # The DoneDate property to test.
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias("dd")]
        [string]$DoneDate,

        # The CreatedDate property to test
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias("cd")]
        [string]$CreatedDate,

        # The Priority property to test.
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias("pri", "u")]
        [string]$Priority,

        # The Tasks property to test.
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias("t")]
        [string]$Task,

        # The Context property to test.
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias("c")]
        [string[]]$Context,

        # The Project property to test.
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias("p")]
        [string[]]$Project,

        # The Addon (key:value pairs) property to test.
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias("a")]
        [string[]]$Addon
    )

    Process {
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