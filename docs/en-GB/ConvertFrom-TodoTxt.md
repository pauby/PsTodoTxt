---
external help file: pstodotxt-help.xml
Module Name: PSTodoTxt
online version: http://www.github.com/pauby/pstodotxt
schema: 2.0.0
---

# ConvertFrom-TodoTxt

## SYNOPSIS
Converts a todo object to a todotxt string.

## SYNTAX

```
ConvertFrom-TodoTxt [-Todo] <PSObject> [<CommonParameters>]
```

## DESCRIPTION
Converts a todo object to a todotxt string.

## EXAMPLES

### EXAMPLE 1
```
$todoObject | ConvertFrom-TodoTxt
```

Converts $todoObject into a todotxt string.

## PARAMETERS

### -Todo
This is the todotxt object (as output from ConvertTo-TodoTxt for example).

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Input type [System.Object]
## OUTPUTS

### Output type [System.String]
## NOTES
Author: Paul Broadwith (https://github.com/pauby)

## RELATED LINKS

[http://www.github.com/pauby/pstodotxt](http://www.github.com/pauby/pstodotxt)

