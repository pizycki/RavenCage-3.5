Import-Module .\Common-Module.psm1 3>$null
Import-Module .\Docker-Module.psm1 3>$null

[boolean] $pushToDockerHub   = [System.Convert]::ToBoolean((Get-EnvVariable "PUSH_TO_DOCKERHUB"))
[string]  $repository        = Get-EnvVariable "DOCKER_REPOSITORY"
[string]  $tag               = Get-EnvVariable "APPVEYOR_REPO_TAG_NAME"
[boolean] $latest            = [System.Convert]::ToBoolean((Get-EnvVariable "IS_LATEST"))
[string]  $dockerHubUser     = Get-EnvVariable "DOCKERHUB_USER"
[string]  $dockerHubPassword = Get-EnvVariable "DOCKERHUB_PASSWORD"

if ( $pushToDockerHub ) {

    Write-Frame "Publishing image to DockerHub" Magenta

    Write-Host "Publishing '${repository}:${tag}'." 
    Push-ImageToDockerHub $repository $tag $dockerHubUser $dockerHubPassword
    Write-Success "Image '${repository}:${tag}' has been published!"

    Write-Host "Is latest? ${latest}"
    if ( $latest ) {
        Write-Host "Publishing '${repository}:${tag}' as 'latest'" 
        Push-ImageToDockerHub $repository "latest" $dockerHubUser $dockerHubPassword
        Write-Success "Image '${repository}:latest' has been pushed to DockerHub!"
    }

    # Removes temporary file that holds user credentials
    # Ref: https://docs.docker.com/engine/reference/commandline/login/
    docker logout
}