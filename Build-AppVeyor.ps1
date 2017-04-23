################################################
# Imports
################################################

Import-Module .\Common.psm1
Import-Module .\Docker.psm1



################################################
# Variables
################################################

[string]  $repository         = Get-EnvVariable "DOCKER_REPOSITORY"
[string]  $dockerHubUser      = Get-EnvVariable "DOCKERHUB_USER"
[string]  $dockerHubPassword  = Get-EnvVariable "DOCKERHUB_PASSWORD"
[string]  $branch             = Get-EnvVariable "APPVEYOR_REPO_BRANCH"
[string]  $tag                = "bla" # Get-EnvVariable "APPVEYOR_REPO_TAG_NAME" # COMMENT IT OUT BEFORE RELEASE
[boolean] $latest             = [System.Convert]::ToBoolean((Get-EnvVariable "IS_LATEST"))
[boolean] $tagged             = [System.Convert]::ToBoolean((Get-EnvVariable "APPVEYOR_REPO_TAG"))
[boolean] $pushToDockerHub    = [System.Convert]::ToBoolean((Get-EnvVariable "PUSH_TO_DOCKERHUB"))



################################################
# Build
################################################

Create-Image $repository $tag

if ( $latest ) {
    TagAsLatest $repository $tag
}



################################################
# Publish
################################################

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