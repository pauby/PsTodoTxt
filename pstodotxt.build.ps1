# This is taken directory from Invoke-Build .build.ps1 at https://github.com/nightroman/Invoke-Build/blob/master/.build.ps1
# will use this as a starting point
<#
.Synopsis
	Build script (https://github.com/pauby/PsTodoTxt)

.Description
	TASKS AND REQUIREMENTS
    Run tests
    Clean the project directory
#>

# Build script parameters are standard parameters
param(
    [switch]$NoTestDiff
)

# Ensure Invoke-Build works in the most strict mode.
Set-StrictMode -Version Latest

# Synopsis: Convert markdown files to HTML.
# <http://johnmacfarlane.net/pandoc/>
task Markdown {
    exec { pandoc.exe --standalone --from=markdown_strict --output=README.htm README.md }
    exec { pandoc.exe --standalone --from=markdown_strict --output=CHANGELOG.htm CHANGELOG.md }
}

# Synopsis: Remove generated and temp files.
task Clean {
    Get-Item z, Tests\z, Tests\z.*, README.htm, Release-Notes.htm, Invoke-Build.*.nupkg -ErrorAction 0 |
        Remove-Item -Force -Recurse
}

# Synopsis: Warn about not empty git status if .git exists.
task GitStatus -If (Test-Path .git) {
    $status = exec { git status -s }
    if ($status) {
        Write-Warning "Git status: $($status -join ', ')"
    }
}

# Synopsis: Build the PowerShell help file.
# <https://github.com/nightroman/Helps>
task Help {
    . Helps.ps1
    Convert-Helps Invoke-Build-Help.ps1 Invoke-Build-Help.xml
}

# Synopsis: Set $script:Version.
task Version {
    # get the version from Release-Notes
    ($script:Version = . { switch -Regex -File Changelog.md {'##\s+v(\d+\.\d+\.\d+)' {return $Matches[1]}} })
    assert $Version
}

# Synopsis: Make the module folder.
task Module Version, {
    # mirror the module folder
    Remove-Item [z] -Force -Recurse
    $dir = "$BuildRoot\z\tools"
    exec {$null = robocopy.exe source $dir /mir} (0..2)

    # copy files
#    Copy-Item -Destination $dir `
#    README.htm,
#    LICENSE,
#    CHANGELOG.htm

    # make manifest
    $scripts = ((Get-Item 'source\public\*.ps1').Name) | ForEach-Object { "'public\$_'" }
    $scripts += ((Get-Item 'source\private\*.ps1').Name) | ForEach-Object { "'private\$_'" }
    $functionsToExport = ((Get-Item 'source\public\*.ps1').BaseName) | ForEach-Object { "'$_'" }
    Set-Content "$dir\PSTodoTxt.psd1" @"
@{
    RootModule = 'PSTodoTxt.psm1'
	ModuleVersion = '$Version'
	GUID = '6533f849-f8fa-4537-b4d1-7e3c21b96291'
	Author = 'Paul Broadwith'
	CompanyName = 'Paul Broadwith'
	Copyright = '(c) 2016-$((Get-Date).Year) Paul Broadwith'
	Description = 'PowerShell implementation of the Todo.txt CLI'
    PowerShellVersion = '3.0'
    FunctionsToExport = @($($functionsToExport -join ', '))
    NestedModules = @($($scripts -join ', '))
	PrivateData = @{
		PSData = @{
			Tags = 'Todo', 'Todo.txt'
			ProjectUri = 'https://github.com/pauby/PSTodoTxt'
			LicenseUri = 'https://github.com/pauby/PsTodoTxt/blob/master/LICENSE'
			ReleaseNotes = 'https://github.com/pauby/PSTodoTxt/blob/master/CHANGELOG.md'
		}
	}
}
"@
}

# Synopsis: Make the NuGet package.
task NuGet Module, {
    $text = @'
Invoke-Build is a build and test automation tool which invokes tasks defined in
PowerShell v2.0+ scripts. It is similar to psake but arguably easier to use and
more powerful. It is complete, bug free, well covered by tests.
'@
    Set-Content z\Package.nuspec @"
<?xml version="1.0"?>
<package xmlns="http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd">
	<metadata>
		<id>Invoke-Build</id>
		<version>$Version</version>
		<authors>Roman Kuzmin</authors>
		<owners>Roman Kuzmin</owners>
		<projectUrl>https://github.com/nightroman/Invoke-Build</projectUrl>
		<iconUrl>https://raw.githubusercontent.com/nightroman/Invoke-Build/master/ib.png</iconUrl>
		<licenseUrl>http://www.apache.org/licenses/LICENSE-2.0</licenseUrl>
		<requireLicenseAcceptance>false</requireLicenseAcceptance>
		<summary>$text</summary>
		<description>$text</description>
		<tags>PowerShell Build Test Automation</tags>
		<releaseNotes>https://github.com/nightroman/Invoke-Build/blob/master/Release-Notes.md</releaseNotes>
		<developmentDependency>true</developmentDependency>
	</metadata>
</package>
"@
    exec { NuGet pack z\Package.nuspec -NoDefaultExcludes -NoPackageAnalysis }
}

# Synopsis: Push with a version tag.
task PushRelease Version, {
    $changes = exec { git status --short }
    assert (!$changes) "Please, commit changes."

    exec { git push }
    exec { git tag -a "v$Version" -m "v$Version" }
    exec { git push origin "v$Version" }
}

# Synopsis: Push NuGet package.
task PushNuGet NuGet, {
    exec { NuGet push "Invoke-Build.$Version.nupkg" -Source nuget.org }
},
Clean

# Synopsis: Calls tests infinitely. NOTE: normal scripts do not use ${*}.
task Loop {
    for () {
        ${*}.Tasks.Clear()
        ${*}.Errors.Clear()
        ${*}.Warnings.Clear()
        Invoke-Build . Tests\.build.ps1
    }
}

# Synopsis: Test and check expected output.
# Requires PowerShelf/Assert-SameFile.ps1
task Test3 {
    # invoke tests, get output and result
    $output = Invoke-Build . Tests\.build.ps1 -Result result -Summary | Out-String -Width:200
    if ($NoTestDiff) {return}

    # process and save the output
    $resultPath = "$BuildRoot\Invoke-Build-Test.log"
    $samplePath = "$HOME\data\Invoke-Build-Test.$($PSVersionTable.PSVersion.Major).log"
    $output = $output -replace '\d\d:\d\d:\d\d(?:\.\d+)?( )? *', '00:00:00.0000000$1'
    [System.IO.File]::WriteAllText($resultPath, $output, [System.Text.Encoding]::UTF8)

    # compare outputs
    Assert-SameFile $samplePath $resultPath $env:MERGE
    Remove-Item $resultPath
}

# Synopsis: Test with PowerShell v2.
task Test2 {
    $diff = if ($NoTestDiff) {'-NoTestDiff'}
    exec {powershell.exe -Version 2 -NoProfile -Command Invoke-Build Test3 $diff}
}

# Synopsis: Test with PowerShell v6.
task Test6 -If $env:powershell6 {
    $diff = if ($NoTestDiff) {'-NoTestDiff'}
    exec {& $env:powershell6 -NoProfile -Command Invoke-Build Test3 $diff}
}

# Synopsis: Test v3+ and v2.
#task Test Test3, Test2, Test6
task Test {
    $pesterParams = @{
        EnableExit = $false;
        PassThru = $true;
        Strict = $true;
        Show = "Failed"
    }

    $results = Invoke-Pester @pesterParams

    $fails = @($results).FailedCount
    assert($fails -eq 0) ('Failed "{0}" unit tests.' -f $fails)
}

task CodeAnalysis {
    $scriptAnalyzerParams = @{
        Path        = "$BuildRoot\source\"
        Severity    = @('Error', 'Warning')
        Recurse     = $true
        Verbose     = $false
    }
    Invoke-ScriptAnalyzer @scriptAnalyzerParams
}

task InstallDependencies {
    $modules = @( "Pester", "PSScriptAnalyzer" ) | ForEach-Object {
        if (!(Get-Module -Name $_ -ListAvailable)) {
            Install-Module $_ -Force
        }
    }
}

# Synopsis: The default task: make, test, clean.
#task . Help, Test, Clean
task . InstallDependencies, Test, Module