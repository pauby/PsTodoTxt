---
external help file: pstodotxt-help.xml
Module Name: PSTodoTxt
online version: https://www.github.com/pauby/pstodotxt
schema: 2.0.0
---

# Import-TodoTxt

## SYNOPSIS
Imports todotxt strings and converts them to objects.

## SYNTAX

```
Import-TodoTxt [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Imports todotxt strings from the source file and converts them to objects.

## EXAMPLES

### EXAMPLE 1
```
Import-Todo -Path c:\todo.txt
```

Reads the todotxt strings from the file c:\todo.txt and converts them to objects.

## PARAMETERS

### -Path
Path to the todo file.
The file must exist.
Throws an exception if the
file does not exist.
Nothing is returned if file is empty.

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object
## NOTES
Author: Paul Broadwith (https://github.com/pauby)

## RELATED LINKS

[https://www.github.com/pauby/pstodotxt](https://www.github.com/pauby/pstodotxt)

