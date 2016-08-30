# Raven Cage
### _Windows Server Container image for hosting RavenDB server instance._

* RavenDB : [official site](https://ravendb.net/)
* Windows Server Containers: [official site at MSDN](https://msdn.microsoft.com/virtualization/windowscontainers/containers_welcome)

## Requirements

Windows 2016 TP3 (tested on TP5) with installed Windows Containers.
To install Windows Containers on your machine follow this [guide](https://msdn.microsoft.com/pl-pl/virtualization/windowscontainers/quick_start/quick_start_windows_server).

## Usage

Run server on port `8080` in `debug` mode and interactive console.

```
docker run -it -p 8080:8080 pizycki/ravendb:latest
```

---
## Build

Build image with this command

Remember to replace `<tag>` with actual tag, i.e.: RavenDB version.

```
docker build -t pizycki/ravendb:<tag> .
```
