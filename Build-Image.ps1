Import-Module .\Common-Module.psm1 3>$null
Import-Module .\Docker-Module.psm1 3>$null

Write-Frame "Building Dockerfile" Magenta

[string]  $repository = Get-EnvVariable "DOCKER_REPOSITORY"
[boolean] $tagged     = [System.Convert]::ToBoolean((Get-EnvVariable "APPVEYOR_REPO_TAG"))
[string]  $tag        = Get-EnvVariable "APPVEYOR_REPO_TAG_NAME"
[boolean] $latest     = [System.Convert]::ToBoolean((Get-EnvVariable "IS_LATEST"))

Write-Host "Check if commit is tagged, if no, break the build."
# Set in AppVeyor flag: Build tags only.
Get-EnvVariable "APPVEYOR_REPO_TAG"

Write-Host -ForegroundColor Green "All looks good! Continue with build."

Write-Host "Build image from Dockerfile."
Create-Image $repository $tag

# Set image as 'latest' according to build settings.
if ( $latest ) {
    Tag-AsLatest $repository $tag
}