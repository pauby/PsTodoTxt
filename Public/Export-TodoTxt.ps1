
function Export-TodoTxt
{
<#
.SYNOPSIS
    Exports todotxt objects.
.DESCRIPTION
    Exports todotxt, previously created with Split-TodoTxt,
    to a text file. Before exporting the todotxt objects are converted
    back to todotxt strings by calling the cmdlet
    Join-TodoTxt.
.NOTES
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 29/04/16 - Initial version
                : 2.0 - 06/09/16 - Completely rewritten to accept pipeline and parameter input.
                  2.1 - 23/01/17 - Refactored code
.LINK
    https://www.github.com/pauby/pstodotxt
.PARAMETER Path
    Path to the todo file. The file will be created if it does not exist.
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
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [PSObject]
        $Todo,

        [Parameter(Mandatory=$true,Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        [switch]
        $Append
    )

    Begin {
    }

    # NOTE:
    # in order to use $input in End{} we CANNOT have a Process{}, even an empty one
    #

    End {
        Write-Verbose "We have $(@($Todo).count) objects in the pipeline to write to $Path."
        if ($VerbosePreference -ne "SilentlyContinue") {
            $toExport | ForEach-Object { Write-Verbose "Object: $_" }
        }

        if ($Append.IsPresent) {
            $Todo | Join-TodoTxt | Add-Content -Path $Path -Encoding UTF8
        }
        else {
            $Todo | Join-TodoTxt | Set-Content -Path $Path -Encoding UTF8
        }
    }
}