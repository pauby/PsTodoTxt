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

    [OutputType([Object])]
	Param(
        [Parameter(Position=0, ValueFromPipeline=$true)] # this parameter is mandatory but we don't want to prompt for it interactively
        [ValidateNotNull()]
        [Object]$Todo,

        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) {
                                return $true
                            } 
                            else {
                                return Test-TodoTxtDate -Date $_  
                            }   
                        } )]
        [Alias('dd')]
        [string]$DoneDate,

        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) {
                                return $true
                            } 
                            else {
                                return Test-TodoTxtDate -Date $_  
                            }   
                        } )]

        [Alias('cd')]
        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) {
                                return $true
                            } 
                            else {
                                return Test-TodoTxtDate -Date $_  
                            }   
                        } )]
        [string]$CreatedDate,

        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) {
                                return $true
                            } 
                            else {
                                return Test-TodoTxtPriority -Priority $_  
                            }   
                        } )]
        [Alias('pri', 'u')]
        [string]$Priority,

        [Alias('t')]
        [string]$Task,

        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) {
                                return $true
                            } 
                            else {
                                return Test-TodoTxtContext -Context $_  
                            }   
                        } )]
        [Alias('c')]
        [string[]]$Context,

        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) {
                                return $true
                            } 
                            else {
                                return Test-TodoTxtContext -Context $_
                            }   
                        } )]
        [Alias('p')]
        [string[]]$Project,

        [Alias('a')]
        [string[]]$Addon
    )

    Begin
    {
        $validParams = @('DoneDate', 'CreatedDate', 'Priority', 'Task', 'Context', 'Project', 'Addon')
<#        $PipelineInput = -not $PSBoundParameters.ContainsKey('Todo')
        if ($PipelineInput) {
            Write-Verbose 'We are taking data from the pipeline.'
        }
        else {
            Write-Verbose 'We are taking data from function parameters.'
        }#>
    }

    Process
    {
 #       if ($PipelineInput) {
 #           $pipe = $_
 #       }
 #       else {
 #           $pipe = $Todo
 #       }

        $Todo | ForEach-Object {
            # either the object passed needs to have a task property or the Task parameter needs to have been used
            if ( (-not ($_ | Test-ObjectProperty -PropertyName 'Task')) -and (-not $PsBoundParameters.ContainsKey('Task')) )  {
                throw [ArgumentException]'For Task not to be required to be set, the object must already have a Task property. If the object does not have a Task property you must set one first.'
            }

            # either the object passed has a CreatedDate property or the CreatedDate parameter needs to have been used
            if ( (-not ($_ | Test-ObjectProperty -PropertyName 'CreatedDate')) -and (-not $PsBoundParameters.ContainsKey('CreatedDate')) )  {
                $_ | Add-Member -MemberType NoteProperty -Name 'CreatedDate' -Value (Get-TodoTxtTodaysDate)
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

            Write-Output $_

            Write-Debug ($_ | Out-String)
        }
   }

    End { 
    }
}