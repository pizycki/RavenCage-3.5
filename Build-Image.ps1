# Creates new version of Docker image with specified tag.

Param(
  [Parameter(Mandatory=$True)]
  [string]$Tag = "",
  [switch]$Latest,
  [string]$Repository = "pizycki/ravendb",
  [switch]$PushToDockerHub,
  [string]$CredentialsPath = "credentials",
  [string]$DockerHubUser = "",
  [string]$DockerHubPass = "",
  [switch]$DontSignOut
)

#### Functions ####

function Create-ImageInRegistry([string]$repository, [string]$tag) {
    
    # Build new Docker image
    write "Building image."
    try {
        docker build --no-cache -t ${repository}:${tag} .
    }
    catch [System.Exception] {
        throw "Error during image build. (${repository}:${tag})"
    }
    write "Image builded!"

    # Check if images is in registery
    write "Checking image in registery..."
    $image_in_registery = (docker images `
                                | sls $repository `
                                | sls $tag).count -gt 0

    if (!($image_in_registery)) {
        throw "Image not found in registery after build. (${repository}:${tag})"
    }
    write "Image found in registery!"
}


function Push-ImageToDockerHub(
    [string]$repository,
    [string]$tag,
    [string]$user,
    [string]$password)
{
    write "Logging in to Docker Hub as [ $user ] ..."
    docker login -u $user -p $password

    if ( $? ) {
        write "Pushing [ ${repository}:${tag} ] to Docker Hub..."
        docker push ${repository}:${tag}
        write "Image pushed!"        
    }
}

function TagAsLatest([string]$repository){
    write "Tagging image [ ${repository}:${tag} ] as latest..."
    docker tag ${repository}:${tag} ${repository}:latest
    write "Tagged as 'latest' !"
}

#### Main ####

# Validate params
if ( [System.String]::IsNullOrWhiteSpace($tag) ) { throw "Tag cannot be null or empty." }
if ( [System.String]::IsNullOrWhiteSpace($repository) ) { throw "Tag cannot be null or empty." }

#### ENV ####

# Start docker if it's not running
try { start docker }
catch [System.InvalidOperationException] { throw "Docker is not in PATH" }

# Check presence of Dockerfile and dockerignore
if ( !(Test-Path ".\Dockerfile") ) { throw "Missing Dockerfile. Are you sure it's Docker repository root?" }
if ( !(Test-Path ".\.dockerignore") ) { throw "Missing dockerignore file" }


#### BUILD ####

# Create image and get image ID
Create-ImageInRegistry $Repository $Tag

# Tag as latest
if ( $Latest ) {
    TagAsLatest $Repository $Tag
}

# DockerHub publish
if ( $PushToDockerHub ) {

    #### Docker Hub credentials ####
    if (Test-Path $CredentialsPath) {

        # Load credentials from file
        $file = Get-Content credentials
        $DockerHubUser = $file[0]
        $DockerHubPass = $file[1]
    }

    # Validate credentials
    if ( [System.String]::IsNullOrWhiteSpace($DockerHubUser) -or `
         [System.String]::IsNullOrWhiteSpace($DockerHubUser) ) {
            throw "Not valid credentials"
    }

    # Publish tagged image to DockerHub
    Push-ImageToDockerHub $Repository $Tag $DockerHubUser $DockerHubPass

    if ( $Latest ) {
        Push-ImageToDockerHub $Repository "latest" $DockerHubUser $DockerHubPass
    }

    if ( !$DontSignOut ) {
        # Removes temporary file that holds user credentials
        # Ref: https://docs.docker.com/engine/reference/commandline/login/
        docker logout
    }
}