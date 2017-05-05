Import-Module .\Common-Module.psm1   3>$null
Import-Module .\Security-Module.psm1 3>$null

Write-Frame "Testing: This script will perform bunch of simple scripts making sure that RavenDB can be run and is accessible." Magenta

[string] $repository = Get-EnvVariable "DOCKER_REPOSITORY"
[string] $tag        = Get-EnvVariable "APPVEYOR_REPO_TAG_NAME"
[string] $name       = "testo"
[int]    $bindPort   = 8080

Write-Host "Enabling port ${bindPort}. Is that ok?"
netsh advfirewall firewall add rule name="Open Port 8080" dir=in action=allow protocol=TCP localport=${bindPort}

Write-Host "Disabling some Windows security features (for testing)."
Disable-UserAccessControl
Disable-InternetExplorerESC
Write-Host "Running '${name}' container."
Write-Host "Container ID will be written below."
docker run -d --name $name -p ${bindPort}:8080 ${repository}:${tag}

Write-Host "Making sure container has started. Docker FAQ says its usualy 10 secs so let's assume that."
Start-Sleep -Seconds 10
Write-Host "Done waiting, proceeding to tests."

Write-Host "Checking container is up."
if ( (docker ps | sls $name).Length -eq 0 ) { Exit-WithError "Test FAILED: No running container with name '${$name}'." }
Write-Success "Container is up and running!"

$ip = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $name
$uri = "http://${ip}:${bindPort}/"
Write-Host "RavenStudio should be hosted on ${uri}"
Write-Host "Sending request to RavenStudio..."
$response = Invoke-WebRequest -Uri $uri
if ( $LastExitCode -ne 0 ) { Exit-WithError "Error while requesting Raven Studio." }    
if ( $response.StatusCode -ne 200 ) { Exit-WithError "Test FAILED: Got non-200 HTTP code." }
Write-Success "Connected to Raven Studio!"

Write-Success "All tests passed." -frame