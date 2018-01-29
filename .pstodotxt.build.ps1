$BuildOptions = @{
    ModuleName              = 'PSTodoTxt'
    PSGalleryApiKey         = $env:PSGALLERY_API_KEY
    BuildPath               = "$BuildRoot\build"
    SourcePath              = "$BuildRoot\source"
    TestsPath               = "$BuildRoot\tests"
    ModuleLoadPath          = "$($env:mysyncroot)\Coding\PowerShell\Modules"
}

$BuildOptions.ModuleFiles   = @((Join-Path -Path $BuildOptions.SourcePath -ChildPath "$($BuildOptions.ModuleName).psd1"),
                                (Join-Path -Path $BuildOptions.SourcePath -ChildPath "$($BuildOptions.ModuleName).psm1"),
                                (Join-Path -Path $BuildOptions.SourcePath -ChildPath "$($BuildOptions.ModuleName).Format.ps1xml"),
                                'LICENSE',
                                (Join-Path -Path $BuildOptions.SourcePath -ChildPath 'en-GB')
                               )

$ManifestOptions = @{
    RootModule              = "$($BuildOptions.ModuleName).psm1"
    Author                  = 'Paul Broadwith'
    CompanyName             = 'Paul Broadwith'
    Copyright               = "(c) 2016-$((Get-Date).Year) Paul Broadwith"
    Description             = 'PowerShell implementation of the Todo.txt CLI'
    PowerShellVersion       = '3.0'
#    DotNetFrameworkVersion  = '4.5'
#    DefaultCommandPrefix    = 'O2'
    FormatsToProcess        = 'PSTodoTxt.Format.ps1xml'
    FunctionsToExport      = (Get-ChildItem (Join-Path $BuildOptions.SourcePath -ChildPath "public\*.ps1") -Recurse).BaseName

    Tags                    = 'Todo', 'Todo.txt'
#    IconUri                 = ''
    ProjectUri              = 'https://github.com/pauby/PSTodoTxt'
    LicenseUri              = 'https://github.com/pauby/PsTodoTxt/blob/master/LICENSE'
    ReleaseNotes            = 'https://github.com/pauby/PSTodoTxt/blob/master/CHANGELOG.md'
}

. .\build.ps1

# Synopsis: The default task: make, test, clean.
#task . Help, Test, Clean
task . GitStatus, InstallDependencies, Test, CodeAnalysis, Build