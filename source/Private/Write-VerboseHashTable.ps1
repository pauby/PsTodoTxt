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