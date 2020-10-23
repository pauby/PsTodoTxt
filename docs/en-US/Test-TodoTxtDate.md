---
external help file: PsTodoTxt-help.xml
Module Name: PsTodoTxt
online version: https://www.github.com/pauby/pstodotxt
schema: 2.0.0
---

# Test-TodoTxtDate

## SYNOPSIS
Tests a date.

## SYNTAX

```
Test-TodoTxtDate [-Date] <String> [<CommonParameters>]
```

## DESCRIPTION
Tests a date for the format yyy-MM-dd.
It does not test to see if the date
is in the future, past or present.

## EXAMPLES

### EXAMPLE 1
```
Test-TodoDate -TestDate '2015-10-10'
```

Tests to ensure the date '2015-10-10' is in the valid todo date format and outputs $true or $false.

## PARAMETERS

### -Date
The date to test.
Note that this is a string and not a date object.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [System.Boolean]
## NOTES
Author: Paul Broadwith (https://github.com/pauby)

TODO: Might be easier to this via a regular expression.

## RELATED LINKS

[https://www.github.com/pauby/pstodotxt](https://www.github.com/pauby/pstodotxt)

