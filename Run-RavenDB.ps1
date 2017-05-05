# Extract RavenDB server ZIP file to folder
#Expand-Archive RavenDB_Server.zip RavenDB

# Delete ZIP file
#Remove-Item RavenDB_Server.zip

# Run server
if( $env:mode -eq "debug" ) {
    C:\RavenDB\Server\Raven.Server.exe --debug
    Write-Verbose "Started RavenDB Server in debug mode."
} else {
    # Register RavenDB as service
    C:\Windows\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe C:\RavenDB\Server\Raven.Server.exe

    # Run RavenDB in background
    Start-Service RavenDB

    Write-Verbose "Started RavenDB Server as service."

    # Keep container alive leaving inf loop
    while ( $true ) { Start-Sleep -Seconds 3600 }
}