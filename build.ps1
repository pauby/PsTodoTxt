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

#if (Test-Path .build.config.ps1) {
#    . .\.build.config.ps1
#}
<#
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

# Synopsis: Push NuGet package.
task PushNuGet NuGet, {
    exec { NuGet push "Invoke-Build.$Version.nupkg" -Source nuget.org }
},
CleanBuild

# Synopsis: Test v3+ and v2.
#task Test Test3, Test2, Test6
task CodeHealth {
    $pesterParams = @{
        EnableExit = $false;
        PassThru = $true;
        Strict = $true;
        Show = "Failed"
    }

    Get-ChildItem -Include '*.ps1', '*.psm1' -Path "$($BuildOptions.SourcePath)" -Recurse | ForEach-Object {
        $type = Split-Path -Path (Split-Path -Path $_.FullName -Parent) -Leaf | Where-Object { $_ -in @("public", "private") }
        $testFilename = "$($_.BaseName).Tests.ps1"
        $testPath = Join-Path -Path (Join-Path -Path "$($BuildOptions.TestsPath)" -ChildPath $type) -ChildPath $testFilename
        $results = Invoke-PSCodeHealth -Path $_ -TestsPath $testPath
        $fails = $results.ScriptAnalyzerFindingsTotal + $results.NumberOfFailedTests 
        assert($fails -eq 0) ("{0} failed {1} tests." -f $testPath, $fails)
    }
}

# Synopsis: Calls tests infinitely. NOTE: normal scripts do not use ${*}.
task Loop {
    for () {
        ${*}.Tasks.Clear()
        ${*}.Errors.Clear()
        ${*}.Warnings.Clear()
        Invoke-Build . Tests\.build.ps1
    }
}
#>

# Synopsis: Remove build folder
task CleanBuild {
    Remove-Item -Path $BuildOptions.BuildPath -Force -Recurse -ErrorAction SilentlyContinue
}

# Synopsis: Cleans the module from all PowerShell module paths
task CleanModule {

    Get-Module $BuildOptions.ModuleName -ListAvailable | ForEach-Object {
        Remove-Module $_.Path -ErrorAction SilentlyContinue
        Remove-Item -Path (Split-Path -Path $_.Path -Parent) -Force -Recurse
    }
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
    $script:Version = . { switch -Regex -File Changelog.md {'##\s+v(\d+\.\d+\.\d+)' {return $Matches[1]}} }
    assert ($Version)
}

# Synopsis: Convert markdown files to HTML.
# <http://johnmacfarlane.net/pandoc/>
task Markdown {
    exec { pandoc.exe --standalone --from=markdown_strict --metadata=title:Readme --output=$($BuildOptions.BuildPath)\README.html README.md }
    exec { pandoc.exe --standalone --from=markdown_strict --metadat=title:Changelog --output=$($BuildOptions.BuildPath)\CHANGELOG.html CHANGELOG.md }
}

# Synopsis: Make the build folder.
task Build CleanBuild, BuildManifest, BuildScriptModule, {
    # create build folder
    New-Item -Path $BuildOptions.BuildPath -ItemType Directory -Force | Out-Null
    # mirror the source folder
    #exec {$null = robocopy.exe $($BuildOptions.SourcePath) $($BuildOptions.BuildPath) /mir} (0..2)

    # copy files
    $BuildOptions.ModuleFiles | Copy-Item -Destination $BuildOptions.BuildPath -Recurse -Passthru | 
        ForEach { Write-Verbose "Copied $($_.name) to build directory" }
}, Markdown

# Synopsis: Builds the module manifest
task BuildManifest Version, BuildScriptModule, {
    # make manifest
    New-ModuleManifest @ManifestOptions `
        -Path (Join-Path -Path $BuildOptions.SourcePath -ChildPath "$($BuildOptions.ModuleName).psd1") `
        -ModuleVersion $Version
}

task BuildScriptModule {
    # build the psm1 module file with all of the scripts
    $modulePath = Join-Path -Path $BuildOptions.SourcePath -ChildPath "$($BuildOptions.ModuleName).psm1"
    Remove-Item $modulePath -Force -ErrorAction SilentlyContinue

    if (Test-Path "$($BuildOptions.SourcePath)\ModuleTop.txt") {
        Get-Content -Path "$($BuildOptions.SourcePath)\ModuleTop.txt" | Add-Content -Path $modulePath
        Write-Verbose "Added ModuleTop.txt to script module." 
    }

    # get a list of all scipts in the public and private directories and subdirectories
    $functions = Get-ChildItem (Join-Path -Path $BuildOptions.SourcePath -ChildPath "public\*.ps1") -Recurse #).FullName)  #| ForEach-Object { "public\$_" }
    $functions += Get-ChildItem (Join-Path -Path $BuildOptions.SourcePath -ChildPath "private\*.ps1") -Recurse -ErrorAction SilentlyContinue #.FullName) #| ForEach-Object { "private\$_" }

    Foreach ($function in $functions) {
        # TODO: Currently it'
        Get-Content -Path $function | Add-Content -Path $modulePath
        "`n" | Add-Content -Path $modulePath
        Write-Verbose "Added $($function.name) to script module." 
    }

    if (Test-Path "$($BuildOptions.SourcePath)\ModuleFooter.txt") { 
        Get-Content -Path "$($BuildOptions.SourcePath)\ModuleFooter.txt" | Add-Content -Path $modulePath
        Write-Verbose "Adding ModuleFooter.txt to script module."
    }
}

# Synopsis: Push with a version tag.
task PushRelease Version, {
    $changes = exec { git status --short }
    assert (!$changes) "Please, commit changes."

    exec { git push }
    exec { git tag -a "v$Version" -m "v$Version" }
    exec { git push origin "v$Version" }
}

task PushPSGallery Test, CodeAnalysis, CleanModule, Build, {
    if (-not $BuildOptions.PSGalleryApiKey) {
        Write-Error "You need to set the environment variable PSGALLERY_API_KEY to the PowerShell Gallery API Key"
    }

    exec {$null = robocopy.exe $($BuildOptions.BuildPath) "$($BuildOptions.ModuleLoadPath)\$($BuildOptions.ModuleName)" /mir} (0..2)
    Write-Verbose "Copied $($BuildOptions.BuildPath) to $($BuildOptions.ModuleLoadPath)\$($BuildOptions.ModuleName)"

    #Import-Module "$($BuildOptions.BuildPath)\$($BuildOptions.ModuleName).psd1"
    Publish-Module -Name $BuildOptions.ModuleName -NuGetApiKey $BuildOptions.PSGalleryApiKey
}, CleanModule, CleanBuild

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

task Test InstallDependencies, BuildManifest, {
    $pesterParams = @{
        EnableExit = $false;
        PassThru   = $true;
        Strict     = $true;
        Show       = "Failed"
    }

    # will throw an error and stop the build if errors
    Test-ModuleManifest "$($BuildOptions.SourcePath)\$($BuildOptions.ModuleName).psd1" -ErrorAction Stop | Out-Null

    # remove the module before we test it
    #Remove-Module $BuildOptions.ModuleName -Force -ErrorAction SilentlyContinue
    #$results = Invoke-Pester @pesterParams
    #$fails = @($results).FailedCount
    #assert($fails -eq 0) ('Failed "{0}" unit tests.' -f $fails)
}

task CodeAnalysis InstallDependencies, {
    $scriptAnalyzerParams = @{
        Path        = $BuildOptions.SourcePath
        Severity    = @('Error', 'Warning')
        Recurse     = $true
        Verbose     = $false
    }
    Invoke-ScriptAnalyzer @scriptAnalyzerParams
}

task InstallDependencies {
    @( "Pester", "PSScriptAnalyzer", "PsCodeHealth", "ModuleBuild") | ForEach-Object {
        if (!(Get-Module -Name $_ -ListAvailable)) {
            Install-Module $_ -Force -Scope CurrentUser
        }
    }
}

