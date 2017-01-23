function Test-TodoTxt
{
    <#
.SYNOPSIS
    Tests a todotxt object.
.DESCRIPTION
    Tests a TodoTxt object properties for valid values.
.NOTES
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 15/09/16 - Initial version

    TODO        : Add test for addons
                  Created a custom TodoObject so that we can check the object type and therefore guarantee it was created by New-TodoTxtObject
.LINK
    https://www.github.com/pauby/pstodotxt
.PARAMETER Todo
    The TodoTxt object to set the properties of.
.PARAMETER DoneDate
    The done date to set. This is only validated as a date in the correct format and can be any date past, future or present. To remove this property value from the object pass $null or an empty string as the parameter value.
.PARAMETER CreatedDate
    The created date to set. This is only validated as a date in the correct format and can be any date past, future or present.  To remove this property value from the object pass $null or an empty string as the parameter value.
.PARAMETER Priority
    The priority of the todo. To remove this property value from the object pass an empty string as the parameter value.
.PARAMETER Task
    The tasks description of the todo. This property cannot be removed.
.PARAMETER Context
    The context(s) of the todo. To remove this property value from the object pass $null or an empty string as the parameter value.
.PARAMETER Project
    The project(s) of the todo. To remove this property value from the object pass $null or an empty string as the parameter value.
.PARAMETER Addon
    The addon key:value pairs of the todo. To remove this property value from the object pass $null or an empty string as the parameter value.
.INPUTS
	Todo object of type [object]
.OUTPUTS
	The modified todo object or type [object]
.EXAMPLE
    $todoObj = $todoObj | Set-TodoTxt -Priority "B"

    Sets the priority of the $todoObj to "B" and outputs the modified todo.
#>

    [CmdletBinding()]
    [OutputType([boolean])]
	Param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [ValidateScript( { Test-TodoTxtDate $_ } )]
        [Alias("dd")]
        [string]$DoneDate,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [ValidateScript( {  Test-TodoTxtDate $_ } )]
        [Alias("cd")]
        [string]$CreatedDate,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [ValidateScript( { Test-TodoTxtPriority $_ } )]
        [Alias("pri", "u")]
        [string]$Priority,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias("t")]
        [string]$Task,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [ValidateScript( { Test-TodoTxtContext $_ } )]
        [Alias("c")]
        [string[]]$Context,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [ValidateScript( { Test-TodoTxtContext $_ } )]  # note we don't use the alias Test-TodoTxtContext here as PSScriptAnaylzer picks up on the alias
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
            $false
        }
        else {
            $true
        }
   }
}