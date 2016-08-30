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
docker run -it -p 80:8080 -v C:\db\:C:\RavenDB\Server\Databases\ pizycki/ravendb
```

**Map ports:** By default RavenDB listens on port 8080. Let's map it to port `80`.

**Map volumes:** By default RavenDB stores its databases in `C:\RavenDB\Server\Databases\`. Let's map it to `C:\db\`. You can also use URI or other disk partitions.

**Raven Studio:** Inspect created container for `IPAddress` and use it to connect to Raven Studio with web browser.

**DON'T CLOSE IT** - for now, you must not close console with running container, since it will terminate application and container work. Yeah, it'll be fixed in future :/

**If you want customize `web.config`** simply map it from your host to config contained in the container. It's located under `C:\RavenDB\Web\web.config` inside container. 


---
## Build

Build image with this command

Remember to replace `<tag>` with actual tag, i.e.: RavenDB version.

```
docker build -t pizycki/ravendb:<tag> .
```
