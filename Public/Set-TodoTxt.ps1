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
.PARAMETER InputObject
    The todo object to set the properties of.
.PARAMETER DoneDate
    The done date to set. This is only validated as a date in the corretc format and can be any date past, future or present.
.PARAMETER CreatedDate
    The created date to set. This is only validated as a date in the corretc format and can be any date past, future or present.
.PARAMETER Priority
    The priority of the todo.
.PARAMETER Task
    The tasks description of the todo.
.PARAMETER Context
    The context(s) of the todo.
.PARAMETER Project
    The project(s) of the todo.
.PARAMETER Addon
    The addon key:value pairs of the todo.
.INPUTS
	Todo object of type [psobject]
.OUTPUTS
	The modified todo object or type [psobject]
.EXAMPLE
    $todoObj = $todoObj | Set-Todo -Priority "B"

    Sets the priority of the $todoObj to "B" and outputs the modified todo.
#>

function Set-TodoTxt
{
    [CmdletBinding()]
	Param(
        [Parameter(Mandatory=$false, Position=1, ValueFromPipeline=$true)] # this parameter is mandatory but we don't want to prompt for it interactively
        [ValidateNotNull()]
        [object[]]$InputObject,     # note if you change this parameter name, change code that excludes checking it below

        [Parameter(Mandatory=$false)]
        [ValidateScript( { $_ -ge 1 } )]
        [Alias("l")]
        [int]$Line,

        [Parameter(Mandatory=$false)]
        [ValidateScript( { Test-TodoTxtDate $_ } )]
        [Alias("dd")]
        [string]$DoneDate,

        [Parameter(Mandatory=$false)]
        [ValidateScript( { Test-TodoTxtDate $_ })]
        [Alias("cd")]
        [string]$CreatedDate,

        [Parameter(Mandatory=$false)]
        [ValidateScript( { Test-TodoTxtPriority $_ } )]
        [Alias("pri", "u")]
        [string]$Priority,

        [Parameter(Mandatory=$false)]
        [Alias("t")]
        [string]$Task,

        [Parameter(Mandatory=$false)]
        [ValidateScript( { Test-TodoTxtContext $_ } )]
        [Alias("c")]
        [string[]]$Context,

        [Parameter(Mandatory=$false)]
        [ValidateScript( { Test-TodoTxtProject $_ } )]
        [Alias("p")]
        [string[]]$Project,

        [Parameter(Mandatory=$false)]
        [Alias("a")]
        [string[]]$Addon
    )

    Begin
    {
    }

    Process
    {
        $result = Assert-MandatoryParameter -MandatoryParameter "InputObject" -PassedParameter $PSBoundParameters
        if ($result -ne $null) {
            throw [System.ArgumentException] "Mandatory parameter missing: $($result -join ',')"
        }

        # if we are not given an existing object to modify, then we need to check that the minimum TodoTxt property of Task is present
        if ( (-not ($InputObject | Test-ObjectProperty -PropertyName "Task")) -and (-not $PsBoundParameters.ContainsKey("Task")) )  {
            throw [System.ArgumentException]"For Task not to be required to be set, the object must already have a Task property. If the object does not have a Task property you must set one first."
        }

        # filter out the InputObject parameter as we won't use it here
        $keys = $PsBoundParameters.Keys | where { $_ -ne "InputObject" }
        foreach ($key in $keys)
        {
            # check to see if the property already exists
            if (($InputObject | Test-ObjectProperty -PropertyName $key))
            {
                # property already exists so just set it to the new value
                $InputObject.$key = $PsBoundParameters.$key
            }
            else
            {
                # property does not already exist to create it with the new value
                $InputObject | Add-Member -MemberType NoteProperty -Name $key -Value $PsBoundParameters.$key
                Write-Debug "Created and set $key to $($InputObject.$key)"
            }
        }

        Write-Debug ($InputObject | Out-String)

        $InputObject
   }

    End { }
}