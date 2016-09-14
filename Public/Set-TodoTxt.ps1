function Set-TodoTxt
{
    <#
.SYNOPSIS
    Sets a todo's properties.
.DESCRIPTION
    Validates and sets a todo's properties.
.NOTES
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 28/09/15 - Initial version

    Notes       : The InputObject should be created using New-TodoTxtObject so the properties are automatically created so this code DOES NOT check if they exist.

    TODO        : Add test for addons
                  Created a custom TodoObject so that we can check the object type and therefore guarantee it was created by New-TodoTxtObject
.LINK
    https://www.github.com/pauby
.PARAMETER Todo
    The todo object to set the properties of.
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
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)] # this parameter is mandatory but we don't want to prompt for it interactively
        [ValidateNotNull()]
        [object[]]$Todo,     # note if you change this parameter name, change code that excludes checking it below

        [Parameter(Mandatory=$false)]
        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) {
                                return $true
                            } 
                            else {
                                return Test-TodoTxtDate $_  
                            }   
                        } )]
        [Alias("dd")]
        [string]$DoneDate,

        [Parameter(Mandatory=$false)]
        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) {
                                return $true
                            } 
                            else {
                                return Test-TodoTxtDate $_  
                            }   
                        } )]

        [Alias("cd")]
        [string]$CreatedDate,

        [Parameter(Mandatory=$false)]
        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) {
                                return $true
                            } 
                            else {
                                return Test-TodoTxtPriority $_  
                            }   
                        } )]
        [Alias("pri", "u")]
        [string]$Priority,

        [Parameter(Mandatory=$false)]
        [Alias("t")]
        [string]$Task,

        [Parameter(Mandatory=$false)]
        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) {
                                return $true
                            } 
                            else {
                                return Test-TodoTxtContext $_  
                            }   
                        } )]
        [Alias("c")]
        [string[]]$Context,

        [Parameter(Mandatory=$false)]
        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) {
                                return $true
                            } 
                            else {
                                return Test-TodoTxtContext $_   # note we don't use the alias Test-TodoTxtProject here as PSScriptAnaylzer picks up on the alias  
                            }   
                        } )]
        [Alias("p")]
        [string[]]$Project,

        [Parameter(Mandatory=$false)]
        [Alias("a")]
        [string[]]$Addon
    )

    Begin
    {
        $validParams = @("DoneDate", "CreatedDate", "Priority", "Task", "Context", "Project", "Addon")
        $converted = @()
        $PipelineInput = -not $PSBoundParameters.ContainsKey("Todo")
        if ($PipelineInput) {
            Write-Verbose "We are taking data from the pipeline."
        }
        else {
            Write-Verbose "We are taking data from function parameters."
        }
    }

    Process
    {
        if ($PipelineInput) {
            $pipe = $_
        }
        else {
            $pipe = $Todo
        }

        $pipe | ForEach-Object {
            # if we are not given an existing object to modify, then we need to check that the minimum TodoTxt property of Task is present
            if ( (-not ($_ | Test-ObjectProperty -PropertyName "Task")) -and (-not $PsBoundParameters.ContainsKey("Task")) )  {
                throw [System.ArgumentException]"For Task not to be required to be set, the object must already have a Task property. If the object does not have a Task property you must set one first."
            }

            # only check for specific parameters 
            $keys = $PsBoundParameters.Keys | Where-Object { $_ -in $validParams }

            # loop through each parameter and set the corresponding proprty on the todotxt object
            foreach ($key in $keys)
            {
                # check to see if the property already exists
                if (($_ | Test-ObjectProperty -PropertyName $key)) {
                    # property already exists so just set it to the new value
                    $_.$key = $PsBoundParameters.$key
                    Write-Verbose "Set $key to $($_.$key)"
                }
                else {
                    # property does not already exist so create it with the new value
                    $_ | Add-Member -MemberType NoteProperty -Name $key -Value $PsBoundParameters.$key
                    Write-Verbose "Created and set $key to $($_.$key)"
                }
            }

            if ($PipelineInput) {
                $converted = $_ 
            }
            else {
                $converted += $_
            }

            Write-Debug ($_ | Out-String)
        }

        return $converted
   }

    End { 
    }
}