function Set-TodoTxt {
<#
.SYNOPSIS
    Sets a todo's properties.
.DESCRIPTION
    Validates and sets a todo's properties.

    The function itself does not validate the Todotxt input object. It does validate the parameters.
.NOTES
    Author: Paul Broadwith (https://github.com/pauby)
.LINK
    https://www.github.com/pauby
.INPUTS
    [System.Object]
.OUTPUTS
    [System.Object]
.EXAMPLE
    $todoObj = $todoObj | Set-TodoTxt -Priority "B"

    Sets the priority of the $todoObj to "B" and outputs the modified todo.
#>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType([System.Object])]
	Param(
        # The todo object to set the properties of.
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [Object]$Todo,

        # The done date to set. This is only validated as a date in the correct
        # format and can be any date past, future or present. To remove this
        # property value from the object pass $null or an empty string as the
        # parameter value.
        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) { $true } else { Test-TodoTxtDate -Date $_ }  } )]
        [Alias('dd', 'done')]
        [string]$DoneDate,

        # The created date to set. This is only validated as a date in the
        # correct format and can be any date past, future or present. As a todo
        # must always have a created date you cannot remove this property value,
        # only change it.
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {  Test-TodoTxtDate -Date $_ } )]
        [Alias('cd', 'created')]
        [string]$CreatedDate,

        # The priority of the todo. To remove this property value from the
        # object pass an empty string as the parameter value.
        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) { $true } else { Test-TodoTxtPriority -Priority $_ }  } )]
        [Alias('pri', 'u')]
        [string]$Priority,

        # The tasks description of the todo. As a todo must always have a task
        # this property cannot be removed.
        [ValidateNotNullOrEmpty()]
        [Alias('t')]
        [string]$Task,

        # The context(s) of the todo. To remove this property value from the
        # object pass $null or an empty string as the parameter value.
        [ValidateScript( { if ( ($null -eq $_) -or ([string]::IsNullOrEmpty($_)) ) { $true } else { Test-TodoTxtContext -Context $_ }  } )]
        [Alias('c')]
        [string[]]$Context,

        # The project(s) of the todo. To remove this property value from the
        # object pass $null or an empty string as the parameter value.
        [ValidateScript( { if ( ($null -eq $_) -or ([string]::IsNullOrEmpty($_)) ) { $true } else { Test-TodoTxtContext -Context $_ }  } )]
        [Alias('p')]
        [string[]]$Project,

        # The addon key:value pairs of the todo. To remove this property value
        # from the object pass $null as the parameter value.
        [Alias('a')]
        [hashtable]$Addon
    )

    Begin {
        $validParams = @('DoneDate', 'CreatedDate', 'Priority', 'Task', 'Context', 'Project', 'Addon')

        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }
    }

    Process {
        $Todo | ForEach-Object {
            # only check for specific parameters
            $keys = $PsBoundParameters.Keys | Where-Object { $_ -in $validParams }

            # loop through each parameter and set the corresponding property on the todotxt object
            foreach ($key in $keys) {
                if ( ($null -eq $PsBoundParameters.$key) -or ([string]::IsNullOrEmpty($PsBoundParameters.$key)) ) {
                    Write-Verbose "Removing property $key"
                    
                    if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
                        $_.PSObject.Properties.Remove($key)
                    }
                }
                else {
                    Write-Verbose "Set $key to $($PSBoundParameters.$key)"
                    if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
                        $_ | Add-Member -MemberType NoteProperty -Name $key -Value $PsBoundParameters.$key -Force
                    } # end if
                } # end else
            } # end foreach

            Write-Debug ($_ | Out-String)
            Write-Output $_
        }
   }

    End {
    }
}