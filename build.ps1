[CmdletBinding()]
Param (
    $Task = 'build'
)

# # Used in Pester tests to import the built module and not a module already installed on the system
# function global:Import-PTHBuildModule {
#     # build the filename
#     $moduleScript = "{0}\{1}.psm1" -f $env:BHBuildOutput, $env:BHProjectName
#     if (Test-Path -Path $moduleScript) {
#         Remove-Module -Name $moduleScript -ErrorAction SilentlyContinue
#         Import-Module -Name $moduleScript -Force -ErrorAction Stop

#         $importedModule = Get-Module -Name $env:BHProjectName
#         Write-Verbose "Imported module '$($importedModule.Path)'"
#     } else {
#         throw "Module manifest '$moduleScript' does not exist!"
#     }
# }

Write-Host "Tag    : $($env:CI_COMMIT_TAG)`nBranch : $($env:CI_COMMIT_REF_NAME)"

Invoke-Build -File .\.pstodotxt.build.ps1 -Task $Task -Verbose:$VerbosePreference

Remove-Item function:Import-HelpersModuleForTesting -ErrorAction SilentlyContinue