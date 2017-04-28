Import-Module .\Common.psm1

function Test-ContainerRunning([string] $name) {
    # Check is container running
    $running_containers = (docker ps | sls $name).Length
    if ( $running_containers -eq 0 ) { Exit-WithError "Test FAILED: No running container." }
}

function Test-RavenStudio([string] $name) {
    $cIP = docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" $name
    $url = "http://${cIP}:8080/"
    $response = Invoke-WebRequest -Uri $url -Method "GET"
    if ( $LastExitCode -ne 0 ) { Exit-WithError "Error while requesting Raven Studio." }    
    if ( $response.StatusCode -ne 200 ) { Exit-WithError "Test FAILED: Raven Studio is not responding." }
}