if ($env:APPVEYOR -ne "True") {
    Clear-Host;
    & .\Before.ps1    
}

& .\Build-Image.ps1
& .\Test-Container.ps1
#& .\Publish-Image.ps1