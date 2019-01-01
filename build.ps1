[CmdletBinding()]
Param (
    $Task = 'build'
)

$dependModules = @(
    @{
        Name = 'InvokeBuild'
    },
    @{
        Name = 'PowerShellBuild'
        MinimumVersion = '0.3.0-beta'
        AllowPrerelease = $true
    }
)

.\Initialize-Build.ps1 -RequiredModule $dependModules -Verbose:$VerbosePreference
. .\tests\TestHelpers.ps1

Invoke-Build -File .\.pstodotxt.build.ps1 -Task $Task -Verbose:$VerbosePreference

Remove-Item function:Import-HelpersModuleForTesting -ErrorAction SilentlyContinue