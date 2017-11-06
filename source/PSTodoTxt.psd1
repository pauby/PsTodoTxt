@{
    RootModule = 'PSTodoTxt.psm1'
    ModuleVersion = '1.0.0'
    GUID = '6533f849-f8fa-4537-b4d1-7e3c21b96291'
    Author = 'Paul Broadwith'
    CompanyName = 'Paul Broadwith'
    Copyright = '(c) 2016-2017 Paul Broadwith'
    Description = 'PowerShell implementation of the Todo.txt CLI'
    PowerShellVersion = '3.0'
    FunctionsToExport = @('ConvertFrom-TodoTxt', 'ConvertTo-TodoTxt', 'Export-TodoTxt', 'Import-TodoTxt', 'Set-TodoTxt')
    NestedModules = @('public\ConvertFrom-TodoTxt.ps1', 'public\ConvertTo-TodoTxt.ps1', 'public\Export-TodoTxt.ps1', 'public\Import-TodoTxt.ps1', 'public\Set-TodoTxt.ps1', 'private\Get-TodoTxtTodaysDate.ps1', 'private\Test-ObjectProperty.ps1', 'private\Test-TodoTxt.ps1', 'private\Test-TodoTxtContext.ps1', 'private\Test-TodoTxtDate.ps1', 'private\Test-TodoTxtPriority.ps1')
    PrivateData = @{
        PSData = @{
            Tags = 'Todo', 'Todo.txt', 'CLI'
            ProjectUri = 'https://github.com/pauby/PSTodoTxt'
            LicenseUri = 'https://github.com/pauby/PsTodoTxt/blob/master/LICENSE'
            ReleaseNotes = 'https://github.com/pauby/PSTodoTxt/blob/master/CHANGELOG.md'
        }
    }
}
