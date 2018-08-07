function ConvertTo-TodoTxt {
    <#
    .SYNOPSIS
        Converts a todo text string to a TodoTxt object.
    .DESCRIPTION
        Converts a todo text string to a TodoTxt object.

        If the task description is not present then you will find that various components of the todo end up as it.

        See the project documentation for the format of the object.
    .NOTES
        Author: Paul Broadwith (https://github.com/pauby)
    .LINK
        http://www.github.com/pauby/pstodotxt
    .INPUTS
        Input type [System.String]
    .OUTPUTS
        Output type [System.Object]
    .EXAMPLE
        ConvertTo-TodoTxt -Todo 'take car to garage @car +car_maintenance'

        Converts the todo text into it's components and returns them in an object.
    .EXAMPLE
        $todo = 'take car to garage @car +car_maintenance'
        $todo | ConvertTo-TodoTxt

        Converts the todo text into it's components and returns them in an object
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("CommunityAnalyzerRules\Measure-Backtick", "", Justification = "Warning as this is a small function with comment based help")]
    [OutputType([System.Object])]
    Param (
        # This is the raw todo text - ie. 'take car to garage @car +car_maintenance'
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Todo,

        [switch]
        $ParseOnly
    )

    Begin {
        # create a hashtable of regular expressions to extract the parts from the Input
        # the format should be:
        #   name    - the object property name that the extracted part will be assigned to
        #   regex   - the regular expression to extract the part
        #
        # Note that as each part is extracted it is also removed from the input so this will affect which
        # anchors used in the expressions
        $regexList = @(
            # the done date - eg. 'x 2017-08-01'
            @{ "name" = "DoneDate"; "regex" = "^x\ \d{4}-\d{2}-\d{2}\ " },
            # priority - eg. '(B)'
            @{ "name" = "Priority"; "regex" = "^\(([A-Za-z])\)\ " },
            # created date - eg. '2016-05-23'
            @{ "name" = "CreatedDate"; "regex" = "^\d{4}-\d{2}-\d{2}\ " },
            # context - eg. '@computer' - can only have ONE @ to be recognised as a context
            @{ "name" = "Context"; "regex" = "(?:^|\s)@[a-z\d-_]+" },
            # project - eg. '+rebuild' - can only have ONE + to be recognised as a project
            @{ "name" = "Project"; "regex" = "(?:^|\s)\+[a-z\d-_]+" },
            # addon - eg. 'due:2017-02-01'
            @{ "name" = "Addon"; "regex" = "(?:^|\s)(\S+)\:((?!//)\S+)" }
        )
    }

    Process {
        $Todo | ForEach-Object {
            Write-Verbose "Processing line: $_"
            $output = New-Object -TypeName PSObject
            if (-not $ParseOnly.IsPresent) {
                $output | Add-Member -MemberType NoteProperty -Name 'CreatedDate' -Value (Get-TodoTxtTodaysDate)
            }
            $output.PSObject.TypeNames.Insert(0, 'TodoTxt')
            $line = $_
            foreach ($item in $regexList) {
                if ($line -match $item.regex) {
                    $found = [regex]::matches($line, $item.regex)
                    $line = $line -replace $item.regex, ""

                    switch ($item.name) {
                        "DoneDate" {
                            try {
                                # the format of the 'done' is 'x <DATE>' so we need
                                # to skip over the x and the space
                                $output | Add-Member -MemberType NoteProperty -Name $_ `
                                    -Value (Get-Date -Date $found.value.SubString(2) -Format "yyyy-MM-dd")
                                Write-Verbose "Found '$_': $($output.$_)"
                                break
                            }
                            catch {
                                if (-not $ParseOnly.IsPresent) {
                                    throw $_
                                }
                            }
                        }

                        "CreatedDate" {
                            try {
                                $output.CreatedDate = (Get-Date -Date $found.value -Format "yyyy-MM-dd")
                                Write-Verbose "Found '$_': $($output.$_)"
                                break
                            }
                            catch {
                                if (-not $ParseOnly.IsPresent) {
                                    throw $_
                                }
                            }
                        }

                        "Priority" {
                            try {
                                # priority is returned as '(<PRIORITY>)' and that
                                # will match the numbered capture (1) in the regex
                                # so we use that
                                $output | Add-Member -MemberType NoteProperty -Name $_ `
                                    -Value ([string]$found.groups[1].value).ToUpper()
                                Write-Verbose "Found '$_': $($output.$_)"
                                break
                            }
                            catch {
                                if (-not $ParseOnly.IsPresent) {
                                    throw $_
                                }
                            }
                        }

                        { $_ -in "Context", "Project" } {
                            $output | Add-Member -MemberType NoteProperty -Name $_ -Value @(
                                $found | foreach-object {
                                    # trim the whitespace and then skip over the
                                    # first characvter which will be @ or +
                                    [string]$_.value.Trim().Remove(0, 1)
                                }
                            )
                            Write-Verbose "Found '$_': $($output.$_)"
                            break
                        }

                        "Addon" {
                            $addons = @{}
                            foreach ($f in $found) {
                                $addons.Add($f.groups[1].value.Trim(), $f.groups[2].value.Trim())
                                Write-Verbose "Found Addon '$($f.groups[1].value)': $($f.groups[2].value)"
                            }
                            $output | Add-Member -MemberType NoteProperty -Name $_ -Value $addons
                            break
                        }
                    } # end switch
                } # end if
            } # end foreach

            # what is left here is the task itself but we need to tidy it up
            # as each part is extracted it's leaving behind double spaces etc.
            $line = ($line -replace "\ {2,}", " ").Trim()
            if ($line.length -lt 1 -and (-not $ParseOnly.IsPresent)) {
                throw "Task description cannot be empty."
            }
            $output | Add-Member -MemberType NoteProperty -Name 'Task' -Value $line
            Write-Verbose "Found 'Task': $($output.task)"

            Write-Output $output
        } # end foreach
    } # end Process

#    End {
#    }
}