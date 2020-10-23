---
external help file: PsTodoTxt-help.xml
Module Name: PsTodoTxt
online version: https://www.github.com/pauby/pstodotxt
schema: 2.0.0
---

# Test-TodoTxtPriority

## SYNOPSIS
Tests a todo priority.

## SYNTAX

```
Test-TodoTxtPriority [-Priority] <String> [<CommonParameters>]
```

## DESCRIPTION
Tests to ensure that the priority is valid.

## EXAMPLES

### EXAMPLE 1
```
Test-TodoPriority "N"
```

Tests to see if the priority "N" is valid and outputs $true or $false.

## PARAMETERS

### -Priority
The priority to test.
A valid priority is a single character string that is between A and Z.

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

