function ConvertTo-TodoTxtString
{
<#
.SYNOPSIS
    Converts a todo text object..
.DESCRIPTION
    Converts a todo text object into a string.
.NOTES
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 31/08/16 - Initial version
.LINK
    http://www.github.com/pauby/pstodotxt
.PARAMETER InputObject
    This is the todotxt object (as output from ConvertFrom-TodoTxtString for example).
.INPUTS
	Input type [PSObject]
.OUTPUTS
	Output type [String]
.EXAMPLE
    $todoObject | ConvertTo-TodoTxtString

	Converts $todoObject into a todotxt string.
.EXAMPLE
    'take car to garage @car +car_maintenance' | ConvertFrom-TodoTxtString | ConvertTo-TodoTxtString

	Converts the string into a todotxt object and then back to a todotxt string.
#>

    [OutputType([array])]
    Param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [PSObject[]]
        $Todo
    )

    Begin {
        # Array index / parts of a todo:
        # 0 - DoneDate (check this exists)
        # 1 - CreatedDate (checked throughout so will exist)
        # 2 - Priority (check this exists)
        # 3 - Task (checked throughout so will exist)
        # 4 - Context (check this exists)
        # 5 - Project (check this exists)
        # 6 - Addon (check this exists)
        $TodoParts = 7
        $converted = @()
        $PipelineInput = -not $PSBoundParameters.ContainsKey("Todo")
        if ($PipelineInput) {
            Write-Verbose "We are taking data from the pipeline."
        }
        else {
            Write-Verbose "We are taking data from function parameters."
        }
    }

    Process {
        if ($PipelineInput) {
            $pipe = $_
        }
        else {
            $pipe = $Todo
        }

        $pipe | ForEach-Object {
            # initialise the array with empty text so we only have to assign valid values
            $text = for ($i = 0; $i -lt $TodoParts; $i++) { "" }

            $index = 0
            if ((Test-ObjectProperty -InputObject $_ -PropertyName "DoneDate") -and (-not ([string]::IsNullOrEmpty($_.DoneDate)))) {
                if (Test-TodoTxtDate $_.DoneDate) {
                    $text[$index] = "x $($_.DoneDate) "
                    Write-Verbose "DoneDate: $($text[$index])"
                }
                else {
                    Write-Error "DoneDate '$($_.DoneDate)' is invalid." -category InvalidArgument
                    return
                }
            }
            $index++

            if ((Test-ObjectProperty -InputObject $_ -PropertyName "CreatedDate") -and (-not ([string]::IsNullOrEmpty($_.CreatedDate)))) {
                if (Test-TodoTxtDate $_.CreatedDate) {
                    $text[$index] = "$($_.CreatedDate) "
                    Write-Verbose "CreatedDate: $($text[$index])"
                }
                else {
                    Write-Error "CreatedDate '$($_.CreatedDate)' is invalid." -Category InvalidArgument
                    return
                }
            }
            $index++

            if ((Test-ObjectProperty -InputObject $_ -PropertyName "Priority") -and (-not ([string]::IsNullOrEmpty($_.Priority)))) {
                if (Test-TodoTxtPriority $_.Priority) {
                    $text[$index] = "($($_.Priority)) "
                    Write-Verbose "Priority: $($text[$index])"
                }
                else {
                    Write-Error "Priority '$($_.Priority)' is invalid."
                    return
                }
            }
            $index++

            $text[$index] = "$($_.Task) "
            Write-Verbose "Task: $($text[$index])"
            $index++

            if ((Test-ObjectProperty -InputObject $_ -PropertyName "Context") -and @($_.Context).count -gt 0) {
                if (Test-TodoTxtContext $_.Context) {
                    $text[$index] = "$( ($_.Context | ForEach-Object { "@$_"}) -join " ") "
                    Write-Verbose "Context: $($text[$index])"
                }
                else {
                    Write-Error "Context '$($_.Context)' is invalid."
                    return
                }
            }
            $index++

            if ((Test-ObjectProperty -InputObject $_ -PropertyName "Project") -and @($_.Project).count -gt 0) {
                if (Test-TodoTxtContext $_.Project) {
                    $text[$index] = "$( ($_.Project | ForEach-Object { "+$_"}) -join " ") "
                    Write-Verbose "Project: $($text[$index])"
                }
                else {
                    Write-Error "Project '$($_.Project)' is invalid."
                    return
                }
            }
            $index++

            if ((Test-ObjectProperty -InputObject $_ -PropertyName "Addon") -and @($_.Addon).count -gt 0) {
                $text[$index] = "$( ($_.Addon.GetEnumerator() | ForEach-Object { "$($_.name):$($_.value)"  }) -join " ") "
                Write-Verbose "Addons: $($text[$index])"
            }

            if ($PipelineInput) {
                $converted = ("{0}{1}{2}{3}{4}{5}{6}" -f $text).Trim()
            }
            else {
                $converted += ("{0}{1}{2}{3}{4}{5}{6}" -f $text).Trim()
            }
        }

        return $converted
    }

    End {
    }
}