function Exit-WithError( $message ){
    $errorExitCode = 1
    Write-Error $message
    $host.SetShouldExit( $errorExitCode )
    exit
}

function Get-EnvVariable( $name ){
    $value = (Get-Item env:$name).Value
    if ( $value -eq $null ) {
        Exit-WithError "Env variable is not set."
    }
    return $value
}

function Write-Frame( [string] $message, [string] $foregroundColor = "White" ) {
    Write-Host -ForegroundColor $foregroundColor "***********************************"
    Write-Host -ForegroundColor $foregroundColor $message
    Write-Host -ForegroundColor $foregroundColor "***********************************"
}

function Write-Success( [string] $message, [switch] $frame ) {    
    if ( $frame ) {
        Write-Frame $message green
    } else {
        Write-Host -ForegroundColor Green $message
    }
}