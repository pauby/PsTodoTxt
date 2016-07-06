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
        [Parameter(Mandatory=$true, Position=1, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
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
        [ValidateScript( { Test-TodoTxtDate $_ } )]
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
        $keys = $PsBoundParameters.Keys | where { $_ -ne "InputObject" }
        foreach ($key in $keys)
        {
            if (($_ | Test-ObjectProperty -PropertyName $key))
            {               
                $_.$key = $PsBoundParameters.$key                                
            }
            else
            {
                $InputObject | Add-Member -MemberType NoteProperty -Name $key -Value $PsBoundParameters.$key
                Write-Debug "Created and set $key to $($InputObject.$key)"
            }
        }
        
        Write-Debug ($InputObject | Out-String)
        
        $_
        
        #$InputObject
        
                #Foreach ($key in $PsBoundParameters.Keys -)
        
<#        if ($DoneDate)
        {
            Write-Verbose "Setting DoneDate to $DoneDate."
            $_.DoneDate = $DoneDate
        }

        if ($CreatedDate)
        {
            Write-Verbose "Setting CreatedDate to $CreatedDate."
            $_.CreatedDate = $CreatedDate
        }

        if ($Priority)
        {
            Write-Verbose "Setting Priority to $Priority."
            $_.Priority = $Priority
        }

        if ($Task)
        {
            Write-Verbose "Setting Task to $Task"
            $_.Task = $Task
        }

        if ($Context)
        {
            Write-Verbose "Setting Context to $($Context -join ", ")."
            $_.Context = $Context
        }

        if ($Project)
        {
            Write-Verbose "Setting Project to $($Project -join ", ")."
            $_.Project = $Project
        }

        if ($DueDate)
        {
            Write-Verbose "Setting DueDate to $DueDate."
            $_.DueDate = $DueDate
        }

        if ($Addon)
        {
            Write-Verbose "Setting Addon to $($Addon -join ", ")."
            $_.Addon = $Addon
        }
                
        Write-Verbose "Object modified. $_"

        $_
#> 
   }

    End { }
}