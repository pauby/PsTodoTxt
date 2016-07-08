<#
.SYNOPSIS
	Creates a new todo object.
.DESCRIPTION
	Creates a new empty todo object.
.NOTES
	File Name	: New-TodoObject
	Author		: Paul Broadwith (paul@pauby.com)
	History		: 1.0 - 18/09/15 - Initial version

    TODO  : Need to remove the functionality to set the properties when creating an ew todo object. The only function that
            uses it is ConvertTo-TodoObject. Use Set-Todo instead as we are duplicating functionality otherwise and this functions
            scope is creeping. This function should only create a blank to object.
.LINK
	https://github.com/pauby/
.PARAMETER Property
	 Properties to set on the new object.
.OUTPUTS
	New todo object [psobject]
.EXAMPLE
	New-TodoObject $props

    Create a new todo object with the properties in $props.
#>

function New-TodoTxtObject
{
    [CmdletBinding()]

    $todoObj = New-Object -Type PSObject #-Property $defaultProps
	$todoObj | Add-Member -MemberType NoteProperty -Name "CreatedDate" -Value (Get-TodoTxtTodaysDate)

    $todoObj
}