---
external help file: PsTodoTxt-help.xml
Module Name: PsTodoTxt
online version: https://github.com/pauby/PsTodoTxt/tree/master/docs/en-US/ConvertTo-TodoTxtDate.md
schema: 2.0.0
---

# ConvertTo-TodoTxtDate

## SYNOPSIS
Converts a date into the TodoTxt date format.

## SYNTAX

```
ConvertTo-TodoTxtDate [[-Date] <DateTime>] [<CommonParameters>]
```

## DESCRIPTION
Converts a date into the TodoTxt date format.

If you do not pass a date then todays date is assumed.

## EXAMPLES

### EXAMPLE 1
```
ConvertTo-TodoTxtDate -Date (Get-Date).AddDays(-20)
```

Converts the date, 20 days ago, into a TodoTxt date format.

## PARAMETERS

### -Date
{{ Fill Date Description }}

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [System.String]
## NOTES
Author: Paul Broadwith (https://github.com/pauby)

## RELATED LINKS

[https://github.com/pauby/PsTodoTxt/tree/master/docs/en-US/ConvertTo-TodoTxtDate.md](https://github.com/pauby/PsTodoTxt/tree/master/docs/en-US/ConvertTo-TodoTxtDate.md)

