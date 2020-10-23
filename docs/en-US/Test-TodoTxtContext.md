---
external help file: PsTodoTxt-help.xml
Module Name: PsTodoTxt
online version: https://www.github.com/pauby/pstodotxt
schema: 2.0.0
---

# Test-TodoTxtContext

## SYNOPSIS
Tests the todo context.

## SYNTAX

```
Test-TodoTxtContext [-Context] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Test the todo context is in the correct format.

## EXAMPLES

### EXAMPLE 1
```
Test-TodoContext "@computer","@home"
```

Tests to see if the contexts "@computer" and "@home" are valid and returns $true or $false.

## PARAMETERS

### -Context
The context(s) to test.
A valid context is a string contains no
whitespace and starting with an '@'

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Project

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

TODO        : The function should only test a single context string so we know which one if any fail.
            At the moment if any of the contexts fail we fail the whole test.

## RELATED LINKS

[https://www.github.com/pauby/pstodotxt](https://www.github.com/pauby/pstodotxt)

