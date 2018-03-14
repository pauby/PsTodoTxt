#Requires -RunAsAdministrator

[CmdletBinding()]
Param ()

$requiredModules = 'InvokeBuild', 'Configuration', 'platyPS', 'PSCodeHealth'
$chocoPackages = 'pandoc', '7zip'

# dependencies
$null = Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

Write-Verbose 'Bootstrapping NuGet package provider.'
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
Set-PSRepository -Name PSGallery -InstallationPOlicy Trusted

$requiredModules | ForEach-Object {
        Write-Verbose "Installing module '$_'."
        Install-Module -Name $_ -SkipPublisherCheck -AllowClobber
        Import-Module -Name $_
}

if (@($chocoPackages.count) -gt 0) {
    # Check if Chocolatey is installed
    $chocoInstalled = $true
    try {
        Write-Verbose 'Checking if Chocolatey is installed'
        Invoke-Expression -Command 'choco.exe' | Out-Null
    }
    catch {
        try {
            Write-Verbose 'Chocolatey not installed. Installing.'
            # taken from https://chocolatey.org/install
            Set-ExecutionPolicy Bypass -Scope Process -Force
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        }
        catch {
            $chocoInstalled = $false
            Write-Verbose 'Could not install Chocolatey'
        }
    }
    
    if ($chocoInstalled) {
        'pandoc', '7zip' | ForEach-Object {
            Write-Verbose "Installing '$_' package."
            choco install $_ -y
        }
    
        Write-Verbose 'Refreshing the PATH'
        refreshenv
    }
} #end if

# Configure git
if ($null -eq (Invoke-Expression -Command 'git config --get user.email')) {
    Write-Verbose 'Git is not configured so we need to configure it now.'
    Invoke-Expression -Command 'git config --global user.email "pauby@users.noreply.github.com"'
    Invoke-Expression -Command 'git config --global user.name "pauby"'
    Invoke-Expression -Command 'git config --global core.safecrlf false'
}