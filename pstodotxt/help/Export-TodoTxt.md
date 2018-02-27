---
external help file: pstodotxt-help.xml
Module Name: pstodotxt
online version: https://www.github.com/pauby/pstodotxt
schema: 2.0.0
---

# Export-TodoTxt

## SYNOPSIS
Exports todotxt objects.

## SYNTAX

```
Export-TodoTxt [-Todo] <PSObject> [-Path] <String> [-Append]
```

## DESCRIPTION
Exports todotxt, previously created with ConvertTo-TodoTxt,
to a text file.
Before exporting the todotxt objects are converted
back to todotxt strings by calling the cmdlet
ConvertFrom-TodoTxt.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$todo = Import-TodoTxt -Path c:\input.txt
```

Export-TodoTxt -Todo $todo -Path c:\output.txt

Converts the todotxt objects in $todo to todotxt strings and writes
them to the file c:\output.txt.

### -------------------------- EXAMPLE 2 --------------------------
```
Import-TodoTxt -Path c:\input.txt | Export-TodoTxt -Path c:\output.txt -Append
```

Imports todotxt strings from c:\input.txt and then exports the file c:\output.txt
by appending them to the end of the file.

## PARAMETERS

### -Todo
Object(s) to export

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

### -Path
Path to the todo file.
The file will be created if it does not exist

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Append
Append to todo file

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

## INPUTS

## OUTPUTS

## NOTES
Author: Paul Broadwith (https://github.com/pauby)

## RELATED LINKS

[https://www.github.com/pauby/pstodotxt](https://www.github.com/pauby/pstodotxt)

