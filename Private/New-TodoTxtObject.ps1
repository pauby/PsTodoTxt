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
	 Properties to set ont he new object.
.OUTPUTS
	New todo object [psobject]
.EXAMPLE
	New-TodoObject $props

    Create a new todo object with the properties in $props.
#>

function New-TodoTxtObject
{
    [CmdletBinding()]
#    Param(
#        [Parameter(Mandatory=$false)]
#        [hashtable]$Property
#    )
        
#	$defaultProps = @{
#		"Line"			= "";		# [int] line number of todotxt in the todotxt file
#		"Canonical" 	= "";		# [string] the todo text as read from the todo file
#		"DoneDate" 		= "";		# [string] date the todo was completed in yyyy-MM-dd format
#		"CreatedDate" 	= (Get-TodoTxtTodaysDate);		# [string] date the todo was created in yyyy-MM-dd format
#		"Priority"		= "";		# [string] todo priority (A - Z)
#		"Task"			= ""; 		# [string] the todo text 
#		"Context"		= @();		# [string[]] the todo context (such as @computer)
#		"Project"		= @();		# [string[]] the project the todo is assigned to (ie. +housebuild)
#		"DueDate"		= "";		# [string] The due date of the todo (uses due:) in the format yyyy-MM-dd
#  		"Threshold"		= "";		# [string] the threshold / start date of a todo (uses t:) in the format yyyy-MM-dd [for future implementation]
#  		"Recurrence"	= "";		# [string]recurring todos (uses rec:) [for future implementation]
#  		"Hidden"		= "";		# dummy todos that are hidden from view (uses h:) [for future implementation]
#        "Addon"         = @();       # additiona key:value pairs that we don't use but will preserve
		  
		# The properties below are calculated by the script and not stored in the todo file
#  		"DueIn"			= "";		# time in days the todo is due
#		"Age"			= "";		# todo age in days (this is not part of the 
#		"Weight"		= "";		# the weighting of this todo
#	}

    $todoObj = New-Object -Type PSObject #-Property $defaultProps

#    if ($Property)
#    {
#        Set-TodoTxt
#    }

    $todoObj
}