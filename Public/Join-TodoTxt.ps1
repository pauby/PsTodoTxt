function Join-TodoTxt
{
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
        $TodoParts = 6
    }

    Process {
        # initialise the array with empty text so we only have to assign valid values
        $text = for ($i = 0; $i -lt $TodoParts; $i++) { "" }

        $index = 0
        if ((Test-ObjectProperty -InputObject $InputObject -PropertyName "DoneDate") -and (-not ([string]::IsNullOrEmpty($InputObject.DoneDate)))) {
            $text[$index] = "x $($InputObject.DoneDate) "
        }
        $index++

        $text[$index] = "$($InputObject.CreatedDate) "
        $index++

        if ((Test-ObjectProperty -InputObject $InputObject -PropertyName "Priority") -and (-not ([string]::IsNullOrEmpty($InputObject.Priority)))) {
            $text[$index] = "($(obj.Priority)) "
        }
        $index++

        $text[$index] = "$($InputObject.Task) "
        $index++

        write-host "$($InputObject.Context.count)"
        if ((Test-ObjectProperty -InputObject $InputObject -PropertyName "Context") -and $InputObject.Context.count -gt 0) {
            $text[$index] = "$($InputObject.Context -join ' ') "
            Write-Host "Context: $($InputObject.Context -join ' ') "
        }
        $index++

        if ((Test-ObjectProperty -InputObject $InputObject -PropertyName "Project") -and $InputObject.Project.count -gt 0) {
            $text[$index] = "$($InputObject.Project -join ' ') "
        }
        $index++

        if ((Test-ObjectProperty -InputObject $InputObject -PropertyName "Addon") -and $InputObject.Addon.count -gt 0) {
            $addons = foreach($addon in $InputObject.Addon) {
                "$($addon[0]):$($addon[1])"
            }

            $text[$index] = $addons -join " "
        }

        "{0}{1}{2}{3}{4}{5}" -f $text
    }

    End {
    }
}