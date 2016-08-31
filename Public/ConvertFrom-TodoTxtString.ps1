<#
.SYNOPSIS
    Splits a todo text string.
.DESCRIPTION
    Splits a todo text string into parts and return back an object.
.NOTES
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 20/06/16 - Initial version
                  1.1 - 31/08/16 - Changed to return an object; Changed name.
    Notes       : The todo 'task' text is mandatory and an error will be thrown if it's not present.
    ##TODO##    : This really needs rewritten to condense it and include more regex to split the todo text in one pass.
                  Remove the Write-Verbose at each component split. The hashtable is printed at the end in verbose mode so no need for it?
.LINK
    http://www.github.com/pauby/pstodotxt
.PARAMETER Todo
    This is the raw todo text - ie. 'take car to garage @car +car_maintenance'
.INPUTS
	Input type [String]
.OUTPUTS
	Output type [PSObject]
.EXAMPLE
    ConvertFrom-TodoTxtString -Todo 'take car to garage @car +car_maintenance'

	Splits the todo text into it's components and returns them in a hashtable.
.EXAMPLE
    $todo = 'take car to garage @car +car_maintenance'
    $todo | ConvertFrom-TodoTxtString

	Splits the todo text into it's components and returns them in a hashtable.
#>

function ConvertFrom-TodoTxtString
{
    [CmdletBinding()]
    [OutputType([PSObject])]
    Param (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Todo
    )

    Begin
    {
        # create regex to extra the first poart of the todo
            # $linePattern = "^(?:x\ (?<done>\d{4}-\d{2}-\d{2})\ )?(?:\((?<prio>[A-Z])\)\ )?(?:(?<created>\d{4}-\d{2}-\d{2})?\ )?(?<task>.*)"
        $regexLine = [regex]"^(?:x\ (?<done>\d{4}-\d{2}-\d{2})\ )?(?:\((?<prio>[A-Za-z])\)\ )?(?:(?<created>\d{4}-\d{2}-\d{2})?\ )?(?<task>.*)"
        $regexContext = [regex]"(?:\s@\S+)" # this regex is also used to replace the context with <blank> so it needs to capture the '@' too or this will be left
            #"((?<=\s)(?:@\S+))+"
        $regexProject = [regex]"(?:\s\+\S+)" # this regex is also used to replace the context with <blank> so it needs to capture the '@' too or this will be left
            #"((?<=\s)(?:\+\S+))+"
        $regexDue = [regex]"(?:due:\d{4}-\d{2}-\d{2})"
            #"(?i)due:(?<due>[0-9]+-[0-9]+-[0-9]+)"
        $regexAddon = [regex]"(?<=\s)(?:\S+\:(?!//)\S+)"
            #"(?:\s\S+\:(?!//)\S+)"
        $lineNum = 0
    }

    Process
    {
        $split = @{}
        Write-Verbose "Original TodoTxt: $Todo"

        # split the todo into components. this regex only splits the first part of the todo. Note that the 'task'
        # contains everything beyond the created date we will then split the rest of the todo using further
        $parsedLine = $regexLine.Match($Todo).Groups

        $split.Add("Task", $parsedLine['task'].Value)
        if ([string]::IsNullOrEmpty($split['task']))
        {
            throw "TodoTxt 'task' cannot be empty."
        }

#region donedate
        if ($parsedLine['done'].Value)
        {
            $split.Add("DoneDate", $parsedLine['done'].Value)
            Write-Verbose "DoneDate: $($split.DoneDate)"
        }
#endregion

#region createdate
        if ($parsedLine['created'].Value)
        {
            $createdDate = $parsedLine['created'].Value
        }
        else
        {
            # no created date on the todo so set it todays date
            $createdDate = Get-TodoTxtTodaysDate
        }
        $split.Add("CreatedDate", $createdDate)
        Write-Verbose "CreatedDate: $($split.CreatedDate)"
#endregion

#region priority
        if ($parsedLine['prio'].Value)
        {
            $split.Add("Priority", $parsedLine['prio'].Value.ToUpper())
            Write-Verbose "Priority: $($split.Priority)"
        }
#endregion

#region context and lists
        if ($regexContext.IsMatch($split['task']))
        {
            # get an array of context:
            # 1. only use unique contexts (if the same one is specified more than once don't add it again),
            # 2. trim each context
            # 3. extract the context without the @ sign (skip over first character)
            $context = @($regexContext.Matches($split['task']) | Get-Unique | % { $_.ToString().Trim() } | % { $_.Substring(1) } )
            $split.Add("Context", $context)
            Write-Verbose "Context ($($split['Context'].Count)): $($split['Context'] -join ',')"

            # as the context was part of the task text, we need to remove it now that we have used it
            $split['task'] = $regexContext.Replace($split['task'], "")
        }
#endregion

#region project and tags
        if ($regexProject.IsMatch($split['task']))
        {
            # get an array of context:
            # 1. only use unique contexts (if the same one is specified more than once don't add it again),
            # 2. trim each context
            # 3. extract the context without the @ sign (skip over first character)
            $project = @($regexProject.Matches($split['task']) | Get-Unique | % { $_.ToString().Trim() } | % { $_.Substring(1) } )
            $split.Add("Project", $project)
            Write-Verbose "Projects ($($split['Project'].Count)): $($split['Project'] -join ',')"

            # remove the matched projects from the rest of the todotxt line
            $split['task'] = $regexProject.Replace($split['task'], "")
        }
#endregion

#region addons
        # find the key:value pairs EXCEPT when there is a // after the : (for example http:// https:// ftp:// etc.
        # each of these get their own object member
        if ($regexAddon.IsMatch($split['task']))
        {
            $addons = @{}
            foreach ($match in $regexAddon.Matches($split['task'])) {
                if ($addons.ContainsKey($match[0])) {
                    Write-Warning "Todo '$Todo' contains multiple '$match[0]' addons. Ignoring."
                }
                else {
                    $parts = $match -split ":"
                    $addons.Add($parts[0], $parts[1])
                }
            }
            $split.Add("Addon", $addons)
            Write-Verbose "Addon ($($split['Addon'].Count)): $($split['Addon'] -join ',')"

            # remove the key:value pairs from the rest of the todotxt
            $split['task'] = $regexAddon.Replace($split['task'], "")
        }
#endregion

#region task text
        # it's mandatory we have a task
        if ([string]::IsNullOrEmpty($split['task']))
        {
            throw "TodoTxt 'task' cannot be empty."
        }
        $split['task'] = $split['task'].Trim()

#endregion
        Write-VerboseHashTable $split

        New-Object -TypeName PSObject -Property $split
    }

    End {}
}