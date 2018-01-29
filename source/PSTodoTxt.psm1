#Requires -Version 3

Set-StrictMode -Version Latest
function ConvertFrom-TodoTxt
{
<#
.SYNOPSIS
    Converts a todo object to a todotxt string.
.DESCRIPTION
    Converts a todo object to a todotxt string.
.NOTES
    Author: Paul Broadwith (https://github.com/pauby)
.LINK
    http://www.github.com/pauby/pstodotxt
.PARAMETER InputObject
.INPUTS
	Input type [System.Object]
.OUTPUTS
	Output type [System.String]
.EXAMPLE
    $todoObject | ConvertFrom-TodoTxt

	Converts $todoObject into a todotxt string.
#>

    [CmdletBinding()]
    [OutputType([System.String])]
    Param (
        # This is the todotxt object (as output from ConvertTo-TodoTxt for example).
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
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


function ConvertTo-TodoTxt
{
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
    [OutputType([System.Object])]
    Param (
        # This is the raw todo text - ie. 'take car to garage @car +car_maintenance'
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Todo
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
            $output = New-Object -TypeName PSObject -Property @{ "CreatedDate" = (Get-TodoTxtTodaysDate) }
            $output.PSObject.TypeNames.Insert(0, 'TodoTxt')
            $line = $_

            foreach ($item in $regexList) {
                if ($line -match $item.regex) {
                    $found = [regex]::matches($line, $item.regex)
                    $line = $line -replace $item.regex, ""

                    switch ($item.name) {
                        "DoneDate" {
                            # the format of the 'done' is 'x <DATE>' so we need
                            # to skip over the x and the space
                            $output | Add-Member -MemberType NoteProperty -Name $_ `
                                -Value (Get-Date -Date $found.value.SubString(2) -Format "yyyy-MM-dd")
                            Write-Verbose "Found '$_': $($output.$_)"
                            break
                        }

                        "CreatedDate" {
                            $output.CreatedDate = (Get-Date -Date $found.value -Format "yyyy-MM-dd")
                            Write-Verbose "Found '$_': $($output.$_)"
                            break
                        }

                        "Priority"  {
                            # priority is returned as '(<PRIORITY>)' and that
                            # will match the numbered capture (1) in the regex
                            # so we use that
                            $output | Add-Member -MemberType NoteProperty -Name $_ `
                                -Value ([string]$found.groups[1].value).ToUpper()
                            Write-Verbose "Found '$_': $($output.$_)"
                            break
                        }

                        { $_ -in "Context", "Project" } {
                            $output | Add-Member -MemberType NoteProperty -Name $_ -Value @(
                                $found | foreach-object { 
                                    # trim the whitespace and then skip over the
                                    # first characvter which will be @ or +
                                    [string]$_.value.Trim().Remove(0,1)
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
            if ($line.length -lt 1) {
                throw "Task description cannot be empty."
            }
            $output | Add-Member -MemberType NoteProperty -Name 'Task' -Value $line
            Write-Verbose "Found 'Task': $($output.task)"

            Write-Output $output
        } # end foreach
    } # end Process

    End {
    }
}


function Export-TodoTxt
{
<#
.SYNOPSIS
    Exports todotxt objects.
.DESCRIPTION
    Exports todotxt, previously created with ConvertTo-TodoTxt,
    to a text file. Before exporting the todotxt objects are converted
    back to todotxt strings by calling the cmdlet
    ConvertFrom-TodoTxt.
.NOTES
    Author: Paul Broadwith (https://github.com/pauby)
.LINK
    https://www.github.com/pauby/pstodotxt
.EXAMPLE
    $todo = Import-TodoTxt -Path c:\input.txt
    Export-TodoTxt -Todo $todo -Path c:\output.txt

    Converts the todotxt objects in $todo to todotxt strings and writes
    them to the file c:\output.txt.
.EXAMPLE
    Import-TodoTxt -Path c:\input.txt | Export-TodoTxt -Path c:\output.txt -Append

    Imports todotxt strings from c:\input.txt and then exports the file c:\output.txt
    by appending them to the end of the file.
#>

    [CmdletBinding()]
    Param(
        # Object(s) to export
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [PSObject]$Todo,

        # Path to the todo file. The file will be created if it does not exist
        [Parameter(Mandatory=$true,Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        # Append to todo file
        [switch]$Append
    )

    Begin {
        if (!$Append.IsPresent -and (Test-Path -Path $Path)) {
            Remove-Item -Path $Path -Force
        }
    }

    Process {
        Write-Verbose "We have $(@($Todo).count) objects in the pipeline to write to $Path."
        if ($VerbosePreference -ne "SilentlyContinue") {
            $Todo | ForEach-Object { Write-Verbose "Object: $_" }
        }

        $Todo | ConvertFrom-TodoTxt | Add-Content -Path $Path -Encoding UTF8
    }
    End {
    }
}


function Import-TodoTxt
{
<#
.SYNOPSIS
    Imports todotxt strings and converts them to objects.
.DESCRIPTION
    Imports todotxt strings from the source file and converts them to objects.
.NOTES
    Author: Paul Broadwith (https://github.com/pauby)
.LINK
    https://www.github.com/pauby/pstodotxt
.OUTPUTS
    System.Object
.EXAMPLE
    Import-Todo -Path c:\todo.txt

    Reads the todotxt strings from the file c:\todo.txt and converts them to objects.
#>

    [CmdletBinding()]
    [OutputType([System.Object])]
    Param (
        # Path to the todo file. The file must exist. Throws an exception if the
        # file does not exist. Nothing is returned if file is empty.
        [Parameter(Mandatory=$true)]
        [ValidateScript( { Test-Path $_ } )]
        [string]$Path
    )

    Write-Verbose "Reading todo file ($Path) contents."
    $todos = Get-Content -Path $Path -Encoding UTF8
    if ($null -eq $todos) {
        Write-Verbose "File $Path is empty."
    }
    else {
        Write-Verbose "Read $(@($todos).count) todos."
        $todos | Where-Object { -not [string]::ISNullOrEmpty($_) } | ConvertTo-TodoTxt
    }
}


function Set-TodoTxt
{
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

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Low')]
    [OutputType([System.Object])]
	Param(
        # The todo object to set the properties of.
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [Object]$Todo,

        # The done date to set. This is only validated as a date in the correct
        # format and can be any date past, future or present. To remove this
        # property value from the object pass $null or an empty string as the
        # parameter value.
        [ValidateScript( {  if ([string]::IsNullOrEmpty($_)) { $true } else { Test-TodoTxtDate -Date $_ }  } )]
        [Alias('dd','done')]
        [string]$DoneDate,

        # The created date to set. This is only validated as a date in the
        # correct format and can be any date past, future or present. As a todo
        # must always have a created date you cannot remove this property value,
        # only change it.
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {  Test-TodoTxtDate -Date $_ } )]
        [Alias('cd','created')]
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

    Begin
    {
        $validParams = @('DoneDate', 'CreatedDate', 'Priority', 'Task', 'Context', 'Project', 'Addon')

        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }
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
                    
                    if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
                        $_.PSObject.Properties.Remove($key)
                    }
                }
                else {
                    Write-Verbose "Set $key to $($PSBoundParameters.$key)"
                    if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
                        $_ | Add-Member -MemberType NoteProperty -Name $key -Value $PsBoundParameters.$key -Force
                    }
                }
            }

            Write-Debug ($_ | Out-String)
            Write-Output $_
        }
   }

    End {
    }
}


function Get-TodoTxtTodaysDate
{
<#
.SYNOPSIS
    Gets todays date in todo.txt format.
.DESCRIPTION
    gets todays date in the correct todo.txt format.
.NOTES
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 29/09/15 - Initial version
.LINK
    https://www.github.com/pauby/
.OUTPUTS
	Todays date. Output type is [datetime]
.EXAMPLE
    Get-TodoTodaysDate

	Outputs todays date.
#>

    Get-Date -Format "yyyy-MM-dd"
}


function Test-ObjectProperty
{
<#
.SYNOPSIS
    Tests an oobject for a property.
.DESCRIPTION
    Tests an object for the existence of a property.
.NOTES
	Author: Paul Broadwith (https://github.com/pauby)
.LINK
    https://www.github.com/pauby/pstodotxt
.INPUTS
	[System.Object]
.OUTPUTS
	[System.Boolean]
.EXAMPLE
    (New-Object -TypeName PSObject -Property @{ test = "testing"} | Test-ObjectProperty -PropertyName "test"

    Tests the object passed on the pipeline for a property named 'test'. In this example the result is $true.
#>

	[CmdletBinding()]
	[OutputType([System.Boolean])]
	Param
	(
		# The object to be tested
		[Parameter(Position=0, ValueFromPipeline=$true)]
		[ValidateScript( { [bool]($_.GetType().Name -eq "PSCustomObject") } )]
		[ValidateNotNull()]
		[PSObject]$InputObject,

		# The property name of the object to be tested
		[Parameter(Position=1)]
		[ValidateNotNullOrEmpty()]
		[string]$PropertyName
	)

	Begin {
		@('InputObject', 'PropertyName') | ForEach-Object {
			if (-not($PSBoundParameters.ContainsKey($_))) {
				throw [ArgumentException]"Mandatory parameter '$_' is missing."
			}
		}		
	}

	Process {
        # check if the object has any properties to check NOTE: not entirely
        # sure we should be using [string]::IsNullOrEmpty() here but it works
        # whereas -eq $null doesn't
        if ([string]::IsNullOrEmpty($InputObject.PSObject.Properties)) {
            $false
        }
        else {
            [bool]($InputObject.PSobject.Properties.name -match $PropertyName)
        }

		# we should never get here
	}

	End	{
	}
}


function Test-TodoTxt
{
<#
.SYNOPSIS
    Tests a todotxt object.
.DESCRIPTION
    Tests a TodoTxt object properties to ensure they conform to the todotxt
    specification.
.NOTES
    Author: Paul Broadwith (https://github.com/pauby)
.LINK
    https://www.github.com/pauby/pstodotxt
.OUTPUTS
    [System.Boolean]
.EXAMPLE
    $obj | Test-TodoTxt

    Tests the properties of the object $obj.
#>

    [CmdletBinding()]
    [OutputType([System.Boolean])]
	Param(
        # The DoneDate property to test.
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias("dd")]
        [string]$DoneDate,

        # The CreatedDate property to test
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias("cd")]
        [string]$CreatedDate,

        # The Priority property to test.
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias("pri", "u")]
        [string]$Priority,

        # The Tasks property to test.
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias("t")]
        [string]$Task,

        # The Context property to test.
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias("c")]
        [string[]]$Context,

        # The Project property to test.
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias("p")]
        [string[]]$Project,

        # The Addon (key:value pairs) property to test.
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias("a")]
        [string[]]$Addon
    )

    Process
    {
        # we didn't mark any parameters mandatory as we didn't want to prompt for them but throw instead
        # test mandatory parameters here
        $mandatoryParams = @( 'CreatedDate', 'Task')
        $keys = @($PsBoundParameters.Keys | Where-Object { $_ -in $mandatoryParams })
        if ($keys.count -ne $mandatoryParams.count) {
            return $false
        }

        # test each parameter passed
        foreach ($key in $PsBoundParameters.Keys) {
            switch ($key) {
                { $_ -in @('DoneDate', 'CreatedDate') } {
                    if (-not (Test-TodoTxtDate $PsBoundParameters.$key)) {
                        return $false
                    }
                    break
                }

                "Priority" {
                    if (-not (Test-TodoTxtPriority $PSBoundParameters.$key)) {
                        return $false
                    }
                    break
                }

                "Task" {
                    if ([string]::IsNullOrEmpty($PSBoundParameters.$key)) {
                        return $false
                    }
                    break
                }

                { $_ -in @( 'Context', 'Project') } {
                    if (-not (Test-TodoTxtContext $PSBoundParameters.$key)) {
                        return $false
                    }
                }
            } #end switch
        } #end foreach

        # if we get here we have passed all Tests
        $true
    } #end process
}


function Test-TodoTxtContext
{
<#
.SYNOPSIS
    Tests the todo context.
.DESCRIPTION
    Test the todo context is in the correct format.
.NOTES
    Author: Paul Broadwith (https://github.com/pauby)

    TODO        : The function should only test a single context string so we know which one if any fail.
                  At the moment if any of the contexts fail we fail the whole test.
.LINK
    https://www.github.com/pauby/pstodotxt
.OUTPUTS
    [System.Boolean]
.EXAMPLE
    Test-TodoContext "@computer","@home"

    Tests to see if the contexts "@computer" and "@home" are valid and returns $true or $false.
#>

    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param (
        # The context(s) to test. A valid context is a string contains no
        # whitespace and starting with an '@'
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Project")]
        [string[]]$Context
    )

    # Context / Project / Tag / List should be a string (or an array of strings)
    $regex = [regex]"^[a-zA-z\d-_]+$"

    foreach ($item in $Context) {
        if (($regex.Match($item)).Success -ne $true) {
            $false
        }
    }

    # if we get here each context must be valid
    $true
}


function Test-TodoTxtDate
{
<#
.SYNOPSIS
    Tests a date.
.DESCRIPTION
    Tests a date for the format yyy-MM-dd. It does not test to see if the date
    is in the future, past or present.
.NOTES
    Author: Paul Broadwith (https://github.com/pauby)

    TODO: Might be easier to this via a regular expression.
.LINK
    https://www.github.com/pauby/pstodotxt
.OUTPUTS
    [System.Boolean]
.EXAMPLE
    Test-TodoDate -TestDate '2015-10-10'

    Tests to ensure the date '2015-10-10' is in the valid todo date format and outputs $true or $false.
#>

    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param (
        # The date to test. Note that this is a string and not a date object.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Date
    )

    # what we do here is first of all pass the date to Get-Date and ask it to format it in yyyy-MM-dd.
    # If it doesn't output the same as the input the date is not in a valid format.
    # also make sure we don't display errors if there is invalid input; instead return $false
    $error.Clear()
    try {
        $result = Get-Date $Date -Format "yyyy-MM-dd" -ErrorAction SilentlyContinue
    }
    catch [System.Exception] {
        return $false
    }

    if ($result.CompareTo($Date) -ne 0 -or $? -eq $false) { # test if the date returned is not the same as the input or we have an error
        $false
    }
    else {
        $true
    }
}


<#
.SYNOPSIS
    Tests a todo priority.
.DESCRIPTION
    Tests to ensure that the priority is valid.
.NOTES
    Author: Paul Broadwith (https://github.com/pauby)
    TODO: Might be easier to this via a regular expression.
.LINK
    https://www.github.com/pauby/pstodotxt
.OUTPUTS
	[System.Boolean]
.EXAMPLE
    Test-TodoPriority "N"

    Tests to see if the priority "N" is valid and outputs $true or $false.
#>
function Test-TodoTxtPriority
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param (
        # The priority to test. A valid priority is a single character string that is between A and Z.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Priority
    )

    # ensure priority is one character long, is a letter between A and Z
    $Priority = $Priority.ToUpper()
    ($Priority.CompareTo("A") -ge 0) -and ($Priority.CompareTo("Z") -le 0) -and ($Priority.Length -eq 1)
}


