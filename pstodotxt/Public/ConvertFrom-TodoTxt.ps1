function ConvertFrom-TodoTxt {
<#
.SYNOPSIS
    Converts a todo object to a todotxt string.
.DESCRIPTION
    Converts a todo object to a todotxt string.
.NOTES
    Author: Paul Broadwith (https://github.com/pauby)
.LINK
    http://www.github.com/pauby/pstodotxt
.INPUTS
    Input type [System.Object]
.OUTPUTS
    Output type [System.String]
.EXAMPLE
    $todoObject | ConvertFrom-TodoTxt

    Converts $todoObject into a todotxt string.
#>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "", Justification = "Causes issue with multi-line if statement")]
    [CmdletBinding()]
    [OutputType([System.String])]
    Param (
        # This is the todotxt object (as output from ConvertTo-TodoTxt for example).
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [PSObject]$Todo
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
                if ( (Test-ObjectProperty -InputObject $todoObj -PropertyName $prop) `
                    -and ($null -ne $todoObj.$prop) `
                    -and (-not [string]::IsNullOrEmpty($todoObj.$prop)) ) {

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