#Requires -Module Pester

# Taken from https://raw.githubusercontent.com/replicaJunction/PSJira/dev/Tests/Shared.ps1
# Dot source this script in any Pester test script that requires the module to be imported.

$ModuleName = 'PsTodoTxt'

$root = $PSScriptRoot -replace "(\\tests.*)"  # root directory of the project (the one below \tests\..)

function Get-TestedScript {
    [CmdletBinding()]
    Param ()

    # using $MyInvocation.PsScriptRoot allows us to use the PSScriptRoot from
    # the calling script. If we just use PSScriptRoot it gives us the root where
    # this script is located   
    $ScriptType = Split-Path $MyInvocation.PSScriptRoot -Leaf | Where-Object { $_ -in @("private", "public") }
    $ScriptFilename = (Split-Path -Leaf $MyInvocation.ScriptName) -replace '\.Tests\.', '.'
    $ScriptPath = ("$root\source\$(Join-Path -Path $ScriptType -ChildPath $ScriptFilename)") 

    "{0,-15} : {1}" -f "Script Type", $scriptType | Write-Verbose
    "{0,-15} : {1}" -f "Script Filename", $scriptFilename | Write-Verbose
    "{0,-15} : {1}" -f "Script Path", $scriptPath | Write-Verbose

    return [PSCustomObject]@{
        Type = $ScriptType;
        Name = $ScriptFilename;
        Path = $ScriptPath
    }
}

function Import-TestedModule {
    [CmdletBinding()]
    Param()
    
    $ModuleManifestPath = "$root\source\$ModuleName.psd1"
    $ModulePath = "$root\source\$ModuleName.psm1"
    if (!(Test-Path $ModulePath)) {
        throw "Module $ModulePath not found."
    }

    # The first time this is called, the module will be forcibly (re-)imported.
    # After importing it once, the $SuppressImportModule flag should prevent
    # the module from being imported again for each test file.

    if (-not (Get-Module -Name $ModuleName -ErrorAction SilentlyContinue) -or (!$SuppressImportModule)) {
        # If we import the .psd1 file, Pester has issues where it detects multiple
        # modules named PSJira. Importing the .psm1 file seems to correct this.

        # -Scope Global is needed when running tests from within a CI environment
        Import-Module $ModulePath -Scope Global -Force

        # Set to true so we don't need to import it again for the next test
        $SuppressImportModule = $true
    }

    "{0,-15} : {1}" -f "Module Manifest", $ModuleManifestPath | Write-Verbose
    "{0,-15} : {1}" -f "Module", $ModulePath | Write-Verbose

    return [PSCustomObject]@{
        ManifestPath = $ModuleManifestPath;
        Path = $ModulePath
    }
}

<#
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope = '*', Target = 'ShowMockData')]
$ShowMockData = $false

[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope = '*', Target = 'ShowDebugText')]
$ShowDebugText = $false

function defProp($obj, $propName, $propValue) {
    It "Defines the '$propName' property" {
        $obj.$propName | Should Be $propValue
    }
}

function defParam($command, $name) {
    It "Has a -$name parameter" {
        $command.Parameters.Item($name) | Should Not BeNullOrEmpty
    }
}

# This function must be used from within an It block
function checkType($obj, $typeName) {
    if ($obj -is [System.Array]) {
        $o = $obj[0]
    }
    else {
        $o = $obj
    }

    $o.PSObject.TypeNames[0] | Should Be $typeName
}

function checkPsType($obj, $typeName) {
    It "Uses output type of '$typeName'" {
        checkType $obj $typeName
    }
}

function ShowMockInfo($functionName, [String[]] $params) {
    if ($ShowMockData) {
        Write-Host "       Mocked $functionName" -ForegroundColor Cyan
        foreach ($p in $params) {
            Write-Host "         [$p]  $(Get-Variable -Name $p -ValueOnly)" -ForegroundColor Cyan
        }
    }
}
#>
