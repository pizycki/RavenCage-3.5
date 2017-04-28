################################################
# Imports
################################################

Import-Module .\Common.psm1
Import-Module .\Docker.psm1
Import-Module .\Tests.psm1


################################################
# Variables
################################################

[string]  $repository         = Get-EnvVariable "DOCKER_REPOSITORY"
[string]  $dockerHubUser      = Get-EnvVariable "DOCKERHUB_USER"
[string]  $dockerHubPassword  = Get-EnvVariable "DOCKERHUB_PASSWORD"
[string]  $branch             = Get-EnvVariable "APPVEYOR_REPO_BRANCH"
[string]  $tag                = Get-EnvVariable "APPVEYOR_REPO_TAG_NAME"
[boolean] $latest             = [System.Convert]::ToBoolean((Get-EnvVariable "IS_LATEST"))
[boolean] $tagged             = [System.Convert]::ToBoolean((Get-EnvVariable "APPVEYOR_REPO_TAG"))
[boolean] $pushToDockerHub    = [System.Convert]::ToBoolean((Get-EnvVariable "PUSH_TO_DOCKERHUB"))


################################################
# Build
################################################

# Check if commit is tagged, if no, break the build.
# Set on AppVeyor flag: Build tags only.
Get-EnvVariable "APPVEYOR_REPO_TAG"

# Continue with build ...

# Build image from Dockerfile
Create-Image $repository $tag

# Set image as 'latest' according to build settings.
if ( $latest ) {
    Tag-AsLatest $repository $tag
}


################################################
# Testing
################################################

# Enable port 8080
netsh advfirewall firewall add rule name="Open Port 8080" dir=in action=allow protocol=TCP localport=8080

# Run container
$cName = "testo"
docker run -d --name $cName ${repository}:${tag}

Test-ContainerRunning $cName
Test-RavenStudio $cName

write "All tests passed."


################################################
# Publish
################################################

# Publish on DockerHub, according to build settings.
if ( $pushToDockerHub ) {

    # Publish tagged image to DockerHub
    Push-ImageToDockerHub $repository $tag $dockerHubUser $dockerHubPassword

    if ( $latest ) {
        Push-ImageToDockerHub $repository "latest" $dockerHubUser $dockerHubPassword
    }

    # Removes temporary file that holds user credentials
    # Ref: https://docs.docker.com/engine/reference/commandline/login/
    docker logout
}