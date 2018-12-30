---
external help file: pstodotxt-help.xml
Module Name: PSTodoTxt
online version: http://www.github.com/pauby/pstodotxt
schema: 2.0.0
---

# ConvertTo-TodoTxt

## SYNOPSIS
Converts a todo text string to a TodoTxt object.

## SYNTAX

```
ConvertTo-TodoTxt [[-Todo] <String[]>] [-ParseOnly] [<CommonParameters>]
```

## DESCRIPTION
Converts a todo text string to a TodoTxt object.

If the task description is not present then you will find that various components of the todo end up as it.

See the project documentation for the format of the object.

## EXAMPLES

### EXAMPLE 1
```
ConvertTo-TodoTxt -Todo 'take car to garage @car +car_maintenance'
```

Converts the todo text into it's components and returns them in an object.

### EXAMPLE 2
```
$todo = 'take car to garage @car +car_maintenance'
```

$todo | ConvertTo-TodoTxt

Converts the todo text into it's components and returns them in an object

## PARAMETERS

### -Todo
This is the raw todo text - ie.
'take car to garage @car +car_maintenance'

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ParseOnly
Requests that the todo not be validated and only parsed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Input type [System.String]
## OUTPUTS

### Output type [System.Object]
## NOTES
Author: Paul Broadwith (https://github.com/pauby)

## RELATED LINKS

[http://www.github.com/pauby/pstodotxt](http://www.github.com/pauby/pstodotxt)

