[CmdletBinding()]
Param (
    $Task = 'build'
)

. .\tests\TestHelpers.ps1

Invoke-Build -File .\.pstodotxt.build.ps1 -Task $Task -Verbose:$VerbosePreference

Remove-Item function:Import-HelpersModuleForTesting -ErrorAction SilentlyContinue