---
external help file: PsTodoTxt-help.xml
Module Name: PsTodoTxt
online version: https://www.github.com/pauby/pstodotxt
schema: 2.0.0
---

# Test-TodoTxt

## SYNOPSIS
Tests a todotxt object.

## SYNTAX

```
Test-TodoTxt [[-DoneDate] <String>] [[-CreatedDate] <String>] [[-Priority] <String>] [[-Task] <String>]
 [[-Context] <String[]>] [[-Project] <String[]>] [[-Addon] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Tests a TodoTxt object properties to ensure they conform to the todotxt
specification.

## EXAMPLES

### EXAMPLE 1
```
$obj | Test-TodoTxt
```

Tests the properties of the object $obj.

## PARAMETERS

### -DoneDate
The DoneDate property to test.

```yaml
Type: String
Parameter Sets: (All)
Aliases: dd

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CreatedDate
The CreatedDate property to test

```yaml
Type: String
Parameter Sets: (All)
Aliases: cd

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Priority
The Priority property to test.

```yaml
Type: String
Parameter Sets: (All)
Aliases: pri, u

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Task
The Tasks property to test.

```yaml
Type: String
Parameter Sets: (All)
Aliases: t

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Context
The Context property to test.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: c

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Project
The Project property to test.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: p

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Addon
The Addon (key:value pairs) property to test.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: a

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [System.Boolean]
## NOTES
Author: Paul Broadwith (https://github.com/pauby)

## RELATED LINKS

[https://www.github.com/pauby/pstodotxt](https://www.github.com/pauby/pstodotxt)

