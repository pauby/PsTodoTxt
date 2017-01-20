function Set-TodoTxt
{
    <#
.SYNOPSIS
    Sets a todo's properties.
.DESCRIPTION
    Validates and sets a todo's properties.

    The function itself does not validate the Todotxt input object. It does validate the parameters.
.NOTES
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 28/09/15 - Initial version
                  1.1 - 19/01/17 - Refactored the code; removed redundant tests

    Notes       : The Todo should be created using so the properties are automatically created so this code DOES NOT check if they exist.

    TODO        : Add test for addons
.LINK
    https://www.github.com/pauby
.PARAMETER Todo
    The todo object to set the properties of.
.PARAMETER DoneDate
    The done date to set. This is only validated as a date in the correct format and can be any date past, future or present.
    To remove this property value from the object pass $null or an empty string as the parameter value.
.PARAMETER CreatedDate
    The created date to set. This is only validated as a date in the correct format and can be any date past, future or present.
    As a todo must always have a created date you cannot remove this property value, only change it.
.PARAMETER Priority
    The priority of the todo. To remove this property value from the object pass an empty string as the parameter value.
.PARAMETER Task
    The tasks description of the todo. As a todo must always have a task this property cannot be removed.
.PARAMETER Context
    The context(s) of the todo. To remove this property value from the object pass $null or an empty string as the parameter value.
.PARAMETER Project
    The project(s) of the todo. To remove this property value from the object pass $null or an empty string as the parameter value.
.PARAMETER Addon
    The addon key:value pairs of the todo. To remove this property value from the object pass $null as the parameter value.
.INPUTS
	Todo object of type [psobject]
.OUTPUTS
	The modified todo object or type [object]
.EXAMPLE
    $todoObj = $todoObj | Set-TodoTxt -Priority "B"

    Sets the priority of the $todoObj to "B" and outputs the modified todo.
#>

    [OutputType([PSObject])]
	Param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [Object]$Todo,

        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) {
                                return $true
                            }
                            else {
                                return Test-TodoTxtDate -Date $_
                            }
                        } )]
        [Alias('dd','done')]
        [string]$DoneDate,

        [ValidateNotNullOrEmpty()]
        [ValidateScript( {  return Test-TodoTxtDate -Date $_ } )]
        [Alias('cd','created')]
        [string]$CreatedDate,       # cannot pass an ampty string to this to wipe it - needs to have a value

        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) {
                                return $true
                            }
                            else {
                                return Test-TodoTxtPriority -Priority $_
                            }
                        } )]
        [Alias('pri', 'u')]
        [string]$Priority,

        [ValidateNotNullOrEmpty()]
        [Alias('t')]
        [string]$Task,  # this cannot be empty as we need a task

        [ValidateScript( { if ( ($null -eq $_) -or ([string]::IsNullOrEmpty($_)) ) {
                                return $true
                            }
                            else {
                                return Test-TodoTxtContext -Context $_
                            }
                        } )]
        [Alias('c')]
        [string[]]$Context,

        [ValidateScript( {  if ( ($null -eq $_) -or ([string]::IsNullOrEmpty($_)) ) {
                                return $true
                            }
                            else {
                                return Test-TodoTxtContext -Context $_
                            }
                        } )]
        [Alias('p')]
        [string[]]$Project,

        [Alias('a')]
        [hashtable]$Addon
    )

    Begin
    {
        $validParams = @('DoneDate', 'CreatedDate', 'Priority', 'Task', 'Context', 'Project', 'Addon')
    }

    Process
    {
        $Todo | ForEach-Object {
            # only check for specific parameters
            $keys = $PsBoundParameters.Keys | Where-Object { $_ -in $validParams }

            # loop through each parameter and set the corresponding property on the todotxt object
            foreach ($key in $keys)
            {
                if ( ($null -eq $PsBoundParameters.$key) -or ([string]::IsNullOrEmpty($PsBoundParameters.$key)) ) {
                    Write-Verbose "Removing property $key"
                    $_.PSObject.Properties.Remove($key)
                }
                else {
                    Write-Verbose "Set $key to $($PSBoundParameters.$key)"
                    $_ | Add-Member -MemberType NoteProperty -Name $key -Value $PsBoundParameters.$key -Force
                }
            }

            Write-Output $_

            Write-Debug ($_ | Out-String)
        }
   }

    End {
    }
}