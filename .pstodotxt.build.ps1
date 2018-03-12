[CmdletBinding()]
Param (
    [ReleaseType]
    $ReleaseType = [ReleaseType]::Unknown,

    [string]
    $GitHubUsername = $env:GITHUB_USERNAME,

    [string]
    $GitHubApiKey = $env:GITHUB_API_KEY,

    [string]
    $PSGalleryApiKey = $env:PSGALLERY_API_KEY
)

$params = @{
    ReleaseType     = $ReleaseType
    GitHubUserName  = $GitHubUsername
    GitHubApiKey    = $GitHubApiKey
    PSGalleryApiKey = $PSGalleryApiKey
}

. (Get-BHBuildScript) @params