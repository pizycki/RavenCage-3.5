function Create-Image( [string] $repository, [string] $tag ) {
    
    write "Building image."

    docker build --no-cache -t ${repository}:${tag} .
    
    if ( $LastExitCode -ne 0 ) { Exit-WithError "Error during image build. (${repository}:${tag})" }
    
    write "Image builded!"

    # Check if images is in registery
    write "Checking image in local registery..."
    $image_in_registery = (docker images `
                          | sls $repository `
                          | sls $tag).count -gt 0

    if ( $image_in_registery -eq $false ) { Exit-WithError "Image not found in registery after build. (${repository}:${tag})" }
    if ( $LastExitCode -ne 0 ) { Exit-WithError "Error during image look up" }

    write "Image found in registery!"
}

function Push-ImageToDockerHub(
         [string]$repository,
         [string]$tag,
         [string]$user,
         [string]$password) {
    
    write "Logging in to Docker Hub as [ $user ] ..."
    docker login -u $user -p $password

    if ( $? ) {
        write "Pushing [ ${repository}:${tag} ] to Docker Hub..."
        docker push ${repository}:${tag}
        if ( $LastExitCode -ne 0 ) { Exit-WithError "Error during pushin image to DockerHub." }
        write "Image pushed!"        
    }
}

function Tag-AsLatest( [string]$repository, [string] $tag ){
    write "Tagging image [ ${repository}:${tag} ] as latest..."
    docker tag ${repository}:${tag} ${repository}:latest
    if ( $LastExitCode -ne 0 ) { Exit-WithError "Error during tagging image as 'latest'." }
    write "Tagged as 'latest' !"
}