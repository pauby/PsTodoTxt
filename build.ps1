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
    },
    @{
        Name = 'Pester'
        MinimumVersion = 4.4.3
    }
)

.\Initialize-Build.ps1 -RequiredModule $dependModules -Verbose:$VerbosePreference
. .\tests\TestHelpers.ps1

Invoke-Build -File .\.pstodotxt.build.ps1 -Task $Task -Verbose:$VerbosePreference

Remove-Item function:Import-HelpersModuleForTesting -ErrorAction SilentlyContinue