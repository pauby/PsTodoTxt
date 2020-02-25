<#
.SYNOPSIS
Converts a date into the TodoTxt date format.

.DESCRIPTION
Converts a date into the TodoTxt date format.

If you do not pass a date then todays date is assumed.

.EXAMPLE
ConvertTo-TodoTxtDate -Date (Get-Date).AddDays(-20)

Converts the date, 20 days ago, into a TodoTxt date format.

.OUTPUTS
    [System.String]

.LINK
    https://github.com/pauby/PsTodoTxt/tree/master/docs/en-US/ConvertTo-TodoTxtDate.md

.NOTES
    Author: Paul Broadwith (https://github.com/pauby)
#>

function ConvertTo-TodoTxtDate {
    [CmdletBinding()]
    [OutputType([System.String])]

    Param (
        [ValidateNotNullOrEmpty()]
        [DateTime]
        $Date = (Get-Date)
    )

    Get-Date -Date $Date -Format 'yyyy-MM-dd'
}