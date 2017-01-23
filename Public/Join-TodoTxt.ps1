function Join-TodoTxt
{
<#
.SYNOPSIS
    Converts a todo text object..
.DESCRIPTION
    Converts a todo text object into a string.
.NOTES
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 31/08/16 - Initial version
                  1.1 - 23/01/17 - Refactored code
.LINK
    http://www.github.com/pauby/pstodotxt
.PARAMETER InputObject
    This is the todotxt object (as output from Split-TodoTxt for example).
.INPUTS
	Input type [PSObject]
.OUTPUTS
	Output type [String]
.EXAMPLE
    $todoObject | Join-TodoTxt

	Converts $todoObject into a todotxt string.
#>

    [CmdletBinding()]
    [OutputType([string])]
    Param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [PSObject]
        $Todo
    )

    Begin {
        $objProps = @('DoneDate', 'Priority', 'CreatedDate', 'Task', 'Context', 'Project', 'Addon')
    }

    Process {
        $joined = ""    # just maiing it clear this is what we are using to hold joined text
        ForEach ($todoObj in $Todo) {

            # valid the todotxt object
            if (-not ($todoObj | Test-TodoTxt)) {
                throw 'Invalid TodoTxt object - invalid or missing properties'
            }

            Foreach ($prop in $objProps) {
                if ( (Test-ObjectProperty -InputObject $todoObj -PropertyName $prop) -and ($null -ne $todoObj.$prop) -and (-not [string]::IsNullOrEmpty($todoObj.$prop)) ) {

                    switch ($prop) {
                        "DoneDate" {
                            $joined += "x $($todoObj.DoneDate) "
                            break
                        }

                        "Priority" {
                            $joined += "($($todoObj.Priority.ToUpper())) "
                            break;
                        }

                        "CreatedDate" {
                            $joined += "$($todoObj.CreatedDate) "
                            break
                        }

                        "Task" {
                            $joined += "$($todoObj.Task) "
                            break
                        }

                        "Context" {
                            $joined += "@$($todoObj.Context -join ' @') "
                            break
                        }

                        "Project" {
                            $joined += "+$($todoObj.Project -join ' +') "
                            break
                        }

                        "Addon" {
                            Foreach ($key in $todoObj.Addon.Keys) {
                                $joined += "$($key):$($todoObj.Addon.$key) "
                            }
                        }
                    } #end switch
                } #end if
            } #end foreach

            Write-Output $joined.Trim()

        } #end foreach
    }

    End {
    }
}