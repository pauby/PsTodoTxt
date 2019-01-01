[CmdletBinding()]
Param (
    $Task = 'build'
)

.\Initialize-Build.ps1 -RequiredModule 'InvokeBuild', 'PowerShellBuild' -Verbose:$VerbosePreference
. .\tests\TestHelpers.ps1

Invoke-Build -File .\.pstodotxt.build.ps1 -Task $Task -Verbose:$VerbosePreference

Remove-Item function:Import-HelpersModuleForTesting -ErrorAction SilentlyContinue