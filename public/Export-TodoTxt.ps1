
function Export-TodoTxt
{
<#
.SYNOPSIS
    Exports todotxt objects.
.DESCRIPTION
    Exports todotxt, previously created with ConvertFrom-TodoTxtString,
    to a text file. Before exporting the todotxt objects are converted
    back to todotxt strings by calling the cmdlet
    ConvertTo-TodoTxtString.
.NOTES
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 29/04/16 - Initial version
                : 2.0 - 06/09/16 - Completely rewritten to accept pipeline and parameter input.
.LINK
    https://www.github.com/pauby/pstodotxt
.PARAMETER Path
    Path to the todo file. The file must already exist.
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
        [object[]]
        $Todo,

        [Parameter(Mandatory=$true,Position=1)]
        [ValidateScript( { if ($PSBoundParameters.ContainsKey("Append")) { Test-Path $_ } else { $true } } )]
        [string]
        $Path,

        [switch]
        $Append
    )

    Begin {
        $PipelineInput = -not $PSBoundParameters.ContainsKey("Todo")
    }

    # NOTE:
    # in order to use $input in End{} we CANNOT have a Process{}
    #

    End {
        if ($PipelineInput) {
            $toExport = @($input)
        }
        else {
            $toExport = $Todo
        }

        Write-Verbose "We have $($toExport.count) objects in the pipeline to write to $Path."
        if ($VerbosePreference -ne "SilentlyContinue") {
            $toExport | ForEach-Object { Write-Verbose "Object: $_" }
        }

        if ($Append.IsPresent) {
            $toExport | ConvertTo-TodoTxtString | Add-Content -Path $Path -Encoding UTF8
        }
        else {
            $toExport | ConvertTo-TodoTxtString | Set-Content -Path $Path -Encoding UTF8
        }
    }
}