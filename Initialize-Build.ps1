[CmdletBinding()]
param()

function Test-Administrator {
    if ($PSVersionTable.Platform -ne 'Unix') {
        $user = [Security.Principal.WindowsIdentity]::GetCurrent();
        (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    } else {
        # TODO: We are running in Linux so assume (at this stage) we have root / Admin - this needs resolved
        $true
    }
}

$dependencies = @{
    InvokeBuild         = 'latest'
#    Configuration       = 'latest'
    PowerShellBuild     = 'latest'
    Pester              = '4.10.1'
    PSScriptAnalyzer    = 'latest'
    PSPesterTestHelpers = 'latest'  # I don't trust this Warren guy...
#    PSDeploy            = 'latest'  # Maybe pin the version in case he breaks this...
}

# dependencies
if (-not (Get-Command -Name 'Get-PackageProvider' -ErrorAction SilentlyContinue)) {
    $null = Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Write-Verbose 'Bootstrapping NuGet package provider.'
    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
} elseif ((Get-PackageProvider).Name -notcontains 'nuget') {
    Write-Verbose 'Bootstrapping NuGet package provider.'
    Get-PackageProvider -Name NuGet -ForceBootstrap
}

# Trust the PSGallery is needed
if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') {
    Write-Verbose "Trusting PowerShellGallery."
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

Install-Module -Name PSDepend

if (Test-Administrator) {
    $dependencies | Invoke-PSDepend -Import -Install -Force
} else {
    Write-Warning "Not running as Administrator - could not initialize build environment."
}

# Configure git
if ($null -eq (Invoke-Expression -Command 'git config --get user.email')) {
    Write-Verbose 'Git is not configured so we need to configure it now.'
    git config --global user.email "pauby@users.noreply.github.com"
    git config --global user.name "pauby"
    git config --global core.safecrlf false
}