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
    This is the todo text object as output from ConvertFrom-TodoTxtString
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
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [PSObject]
        $InputObject
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
    }

    Process {
        # initialise the array with empty text so we only have to assign valid values
        $text = for ($i = 0; $i -lt $TodoParts; $i++) { "" }

        $index = 0
        if ((Test-ObjectProperty -InputObject $InputObject -PropertyName "DoneDate") -and (-not ([string]::IsNullOrEmpty($InputObject.DoneDate)))) {
            $text[$index] = "x $($InputObject.DoneDate) "
            Write-Verbose "DoneDate: $($text[$index])"
        }
        $index++

        $text[$index] = "$($InputObject.CreatedDate) "
        Write-Verbose "CreatedDate: $($text[$index])"
        $index++

        if ((Test-ObjectProperty -InputObject $InputObject -PropertyName "Priority") -and (-not ([string]::IsNullOrEmpty($InputObject.Priority)))) {
            $text[$index] = "($(obj.Priority)) "
            Write-Verbose "Priority: $($text[$index])"
        }
        $index++

        $text[$index] = "$($InputObject.Task) "
        Write-Verbose "Task: $($text[$index])"
        $index++

        if ((Test-ObjectProperty -InputObject $InputObject -PropertyName "Context") -and $InputObject.Context.count -gt 0) {
            $newContext = @()
            foreach ($item in $InputObject.Context) {
                $newContext += "@$item"
            }
            $text[$index] = "$($newContext -join ' ') "
            Write-Verbose "Context: $($text[$index])"
        }
        $index++

        if ((Test-ObjectProperty -InputObject $InputObject -PropertyName "Project") -and $InputObject.Project.count -gt 0) {
            $newProject = @()
            foreach ($item in $InputObject.Project) {
                $newProject += "+$item"
            }
            $text[$index] = "$($newProject -join ' ') "
            Write-Verbose "Project: $($text[$index])"
        }
        $index++

        if ((Test-ObjectProperty -InputObject $InputObject -PropertyName "Addon") -and $InputObject.Addon.count -gt 0) {
            $addons = @() 
            foreach($addon in $InputObject.Addon) {
                $addons += "$($addon[0]):$($addon[1])"
            }
            $text[$index] = $addons -join " "
            Write-Verbose "Addons: $($text[$index])"
        }

        "{0}{1}{2}{3}{4}{5}{6}" -f $text
    }

    End {
    }
}