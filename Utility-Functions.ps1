<# 
.SYNOPSIS
    A collection of miscellaneous small utility functions.
.DESCRIPTION
    A collection of miscellaneous small utility functions that don't deserve their own script file.
.NOTES 
    File Name	: Utility-Functions.ps1
    Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 29/09/15 - Initial version
.LINK 
    https://www.github.com/pauby/ 
#>

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
function Get-TodoTxtTodaysDate
{
    Get-Date -Format "yyyy-MM-dd"
}


<#
.SYNOPSIS
    Writes a formatted hashtable in verbose mode. 
.DESCRIPTION
    Writes a formatted hashtable in the verbose format. When a you pass a hashtabnle to Write-Verbose it is not formatted correctly.
    If $VerbosePreference -eq "SilentlyContinue" then nothing will be written as the function makes use of Write-Verbose.
.NOTES
	Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 20/06/16 - Initial version
.LINK
    https://www.github.com/pauby
.PARAMETER HashTable
    HashTable to write.
.EXAMPLE
    Write-VerboseHashTable $ht

    Writes the hashtavble $ht as formatted verbose text.
#>

function Write-VerboseHashTable
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,Position=0)]
        [hashtable]$HashTable
    )

    if ($VerbosePreference -ne "SilentlyContinue")
    {
        $columnWidth = $HashTable.Keys.length | Sort-Object| Select-Object -Last 1
        Write-Verbose ("  {0,-$columnWidth}   {1}" -F "Name", "Value") -Verbose
        Write-Verbose ("  {0,-$columnWidth}   {1}" -F "----", "-----") -Verbose
        $HashTable.GetEnumerator() | ForEach-Object {
            if ($_.Value -is "array") {
                $value = ($_.Value -join ",")
            }
            else {
                $value = $_.value
            }
                    Write-Verbose ("  {0,-$columnWidth} : {1}" -F $_.Key, $value) -Verbose
        }
    }
}