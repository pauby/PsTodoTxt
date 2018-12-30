Import-Module PowerShellBuild -force
. PowerShellBuild.IB.Tasks

$PSBPreference.Build.CompileModule = $true
# $PSBPreference.Build.Dependencies                           = 'StageFiles', 'BuildHelp'
$PSBPreference.Test.Enabled                                 = $true
$PSBPreference.Test.CodeCoverage.Enabled                    = $true
$PSBPreference.Test.CodeCoverage.Threshold                  = 0.75
$PSBPreference.Test.CodeCoverage.Files                      =
    (Join-Path -Path $PSBPreference.Build.ModuleOutDir -ChildPath "*.psm1")
$PSBPreference.Test.ScriptAnalysis.Enabled                  = $true
$PSBPreference.Test.ScriptAnalysis.FailBuildOnSeverityLevel = 'Error'

task LocalDeploy {
    $sourcePath = $PSBPreference.Build.ModuleOutDir
    $destPath = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) `
        -ChildPath "WindowsPowerShell\Modules\$($PSBPreference.General.ModuleName)\$($PSBPreference.General.ModuleVersion)\"

    if (Test-Path -Path $destPath) {
        Remove-Item -Path $destPath -Recurse -Force
    }
    Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Force
}

# task compilemodule {
#     ipmo modulebuilder
#     $params = @{
#         SourcePath               = $PSBPreference.General.SrcRootDir
#         OutputDirectory          = $PSBPreference.Build.OutDir
#         VersionedOutputDirectory = $true
#         Version                  = $PSBPreference.General.ModuleVersion
#         Prefix                   = if ($PSBPreference.Build.Contains('Prefix')) { $PSBPreference.Build.PrefixFile } else { '' }
#         Suffix                   = if ($PSBPreference.Build.Contains('Suffix')) { $PSBPreference.Build.SuffixFile } else { '' }
#     }

#     build-module @params
# }
