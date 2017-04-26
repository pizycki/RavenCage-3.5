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