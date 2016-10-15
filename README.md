# RavenDB in Docker container

This container spins up RavenDB single node server instance.

* RavenDB : [official site](https://ravendb.net/)
* Docker: [official site](https://www.docker.com/)
* Windows Containers: [site at MSDN](https://msdn.microsoft.com/virtualization/windowscontainers/containers_welcome)

# Requirements

Windows 2016 build 14393 with installed Windows Containers.
To install Windows Containers on your machine follow this [guide](https://msdn.microsoft.com/pl-pl/virtualization/windowscontainers/quick_start/quick_start_windows_server).

## Usage

### Run in background
Run server on port `8080` as service.

```
docker run -d pizycki/ravendb:latest
```

### Run in console and debug mode
Run server on port `8080` in `debug` mode and interactive console.

```
docker run -it -e mode=debug pizycki/ravendb:latest
```

> Running on IIS is not supported here.

### Map storage
Map directory where your databases will be stored to `C:\db\` on your host. You can also map place in your network.
```
docker run -d -v C:\db\:C:\RavenDB\Server\Databases\ pizycki/ravendb:latest 
```

### Map RavenDB listen port
Make you container listen on port `5555`
```
docker run -d -p 5555:8080 pizycki/ravendb:latest 
```

> Both **volume** and **port** mapping work with either `service` and `debug` mode.

---

## Build

Build image with this command

Remember to replace `<tag>` with actual tag, i.e.: RavenDB version.

```
docker build -t pizycki/ravendb:<tag> .
```

# FAQ

## I cannot access my RavenDB server website.
There is something wrong with `localhost`, Win2016 and Docker. I have no idea what can that be.
To get access to RavenDB website, get container IP. Simply type `docker inspect <container_ID>` and look for `Networks.IPAddress`.
Make sure the port you mapped to is open in your firewall settings!

## Will this work on Windows 10?
No. Right now, Windows 10 supports only Windows Nano based containers, running on top of HyperV.

_ref: [Are microsoft/windowsservercore containers working on Windows 10?](http://www.busydevelopers.com/article/44081337/Are+microsoft+windowsservercore+containers+working+on+Windows+10%3F)_
