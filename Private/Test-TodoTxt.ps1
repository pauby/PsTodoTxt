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
    [OutputType([Object[]])]
	Param(
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) {
                                return $true
                            }
                            else {
                                return Test-TodoTxtDate $_
                            }
                        } )]
        [Alias("dd")]
        [string]$DoneDate,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {  Test-TodoTxtDate $_ } )]
        [Alias("cd")]
        [string]$CreatedDate,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) {
                                return $true
                            }
                            else {
                                return Test-TodoTxtPriority $_
                            }
                        } )]
        [Alias("pri", "u")]
        [string]$Priority,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias("t")]
        [string]$Task,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) {
                                return $true
                            }
                            else {
                                return Test-TodoTxtContext $_
                            }
                        } )]
        [Alias("c")]
        [string[]]$Context,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) {
                                return $true
                            }
                            else {
                                return Test-TodoTxtContext $_   # note we don't use the alias Test-TodoTxtContext here as PSScriptAnaylzer picks up on the alias
                            }
                        } )]
        [Alias("p")]
        [string[]]$Project,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Alias("a")]
        [string[]]$Addon
    )

    Process
    {
        # all the parameter testing has already been done in the parameter validation so if we get here
        # we just need to pass back $true

        Write-Output $true
   }
}

#(New-Object -TypeName PSObject -Property @{ CreatedDate = "2017-09-88"; Task = "Lets go to the Degobah system" } ) | Test-TodoTxt