# download latest
[CmdletBinding()]
Param (
    [switch]$Force
)

$rulesPath = (Join-Path -Path $PSScriptRoot -ChildPath "Tests\Rules")
$rulesURL = @( "https://raw.githubusercontent.com/PowerShell/PSScriptAnalyzer/development/Tests/Engine/CommunityAnalyzerRules/CommunityAnalyzerRules.psd1",
                "https://raw.githubusercontent.com/PowerShell/PSScriptAnalyzer/development/Tests/Engine/CommunityAnalyzerRules/CommunityAnalyzerRules.psm1"
            )

# the force parameter requires us to download the files anyway so no need to check this next bit
if (-not $Force) {
    Write-Verbose "Checking we have the rules already downloaded."
    $forceDownload = $false
    foreach ($rule in $rulesUrl) {
        $filename = Split-Path -Path $rule -Leaf
        if (-not (Test-Path $filename)) {
            Write-Verbose "One or more rules are missing so downloading."
            $forceDownload = $true
            break
        }
    }
}

if ($Force -or $forceDownload) {
    Write-Verbose "Downloading rules."
    foreach ($rule in $rulesURL) {
        $filename = Split-Path -Path $rule -Leaf
        Write-Verbose "Downlaoding $rule"
        try {
            Invoke-WebRequest -Uri $rule -Out (Join-Path -Path $rulesPath -ChildPath $filename)
        }
        catch [System.Exception] {
            Write-Error "Cannot download $rule"
            break
        }
    }
}

# Before we import any modules we must import PSScriptAnalyzer
try {
    Write-Verbose "Importing PSScriptAnalyzer"
    Import-Module PSScriptAnalyzer
}
catch
{
    Write-Host "The PSScriptAnalyzer module must be available to import."
}

# Import any modules
# we find the modules by checking the extension of the url's we download - modules are classified as having the extension psd1
$rulesModules = $rulesUrl | where { [io.path]::GetExtension($_) -match ".psd1" } | Split-Path -Leaf
foreach ($module in $rulesModules) {
    Write-Verbose "Importing Script Analyzer Rules module $module"
    Import-Module (Join-Path -Path $rulesPath -ChildPath $module)
}

$tests = get-childitem tests\*.tests.ps1

foreach ($test in $tests) {
    Invoke-Pester $test.fullname
}