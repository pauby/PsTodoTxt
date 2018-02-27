---
external help file: pstodotxt-help.xml
Module Name: pstodotxt
online version: https://www.github.com/pauby
schema: 2.0.0
---

# Set-TodoTxt

## SYNOPSIS
Sets a todo's properties.

## SYNTAX

```
Set-TodoTxt [-Todo] <Object> [-DoneDate <String>] [-CreatedDate <String>] [-Priority <String>] [-Task <String>]
 [-Context <String[]>] [-Project <String[]>] [-Addon <Hashtable>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Validates and sets a todo's properties.

The function itself does not validate the Todotxt input object.
It does validate the parameters.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$todoObj = $todoObj | Set-TodoTxt -Priority "B"
```

Sets the priority of the $todoObj to "B" and outputs the modified todo.

## PARAMETERS

### -Todo
The todo object to set the properties of.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -DoneDate
The done date to set.
This is only validated as a date in the correct
format and can be any date past, future or present.
To remove this
property value from the object pass $null or an empty string as the
parameter value.

```yaml
Type: String
Parameter Sets: (All)
Aliases: dd, done

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreatedDate
The created date to set.
This is only validated as a date in the
correct format and can be any date past, future or present.
As a todo
must always have a created date you cannot remove this property value,
only change it.

```yaml
Type: String
Parameter Sets: (All)
Aliases: cd, created

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Priority
The priority of the todo.
To remove this property value from the
object pass an empty string as the parameter value.

```yaml
Type: String
Parameter Sets: (All)
Aliases: pri, u

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Task
The tasks description of the todo.
As a todo must always have a task
this property cannot be removed.

```yaml
Type: String
Parameter Sets: (All)
Aliases: t

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Context
The context(s) of the todo.
To remove this property value from the
object pass $null or an empty string as the parameter value.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: c

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Project
The project(s) of the todo.
To remove this property value from the
object pass $null or an empty string as the parameter value.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: p

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Addon
The addon key:value pairs of the todo.
To remove this property value
from the object pass $null as the parameter value.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: a

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### [System.Object]

## OUTPUTS

### [System.Object]

## NOTES
Author: Paul Broadwith (https://github.com/pauby)

## RELATED LINKS

[https://www.github.com/pauby](https://www.github.com/pauby)

