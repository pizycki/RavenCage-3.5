# RavenDB in Docker container

This container spins up RavenDB single node server instance.

* RavenCage on DockerHub : [repository](https://hub.docker.com/r/pizycki/ravendb/)
* RavenCage on GitHub : [repository](https://github.com/pizycki/RavenCage)
* RavenDB : [official site](https://ravendb.net/)
* Docker : [official site](https://www.docker.com/)
* Windows Containers : [site at MSDN](https://msdn.microsoft.com/virtualization/windowscontainers/containers_welcome)

[![DockerHub Stars](https://img.shields.io/docker/stars/pizycki/ravendb.svg)](https://hub.docker.com/r/pizycki/ravendb) [![DockerHub Pulls](https://img.shields.io/docker/pulls/pizycki/ravendb.svg)](https://hub.docker.com/r/pizycki/ravendb) [![GitHub stars](https://img.shields.io/github/stars/pizycki/ravencage-3.5.svg?style=social&label=Star)](https://github.com/pizycki/RavenCage-3.5) [![Build status](https://ci.appveyor.com/api/projects/status/ab7oryewihivh46x?svg=true)](https://ci.appveyor.com/project/pizycki/ravencage-3-5)

# Requirements

Windows 2016 build 14393 or Windows 10 build 14393.222 with installed Windows Containers.
To check your OS build, `Win+R` and type `winver`.
At this moment Windows 10 supports Hyper-V Containers only.

To install Windows Containers on your machine follow on of there guides: [Windows Server 2016](https://msdn.microsoft.com/pl-pl/virtualization/windowscontainers/quick_start/quick_start_windows_server), [Windows 10](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/quick_start/quick_start_windows_10)

## Usage
For Windows Server 2016

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

### Automated 
[![Build status](https://ci.appveyor.com/api/projects/status/ab7oryewihivh46x?svg=true)](https://ci.appveyor.com/project/pizycki/ravencage-3-5)

Automated builds are initialized on every **tagged** commit. 

Thanks to [AppVeyor](http://appyveyor.com) for letting use their platform! **You are the real MVP!**

### Manual
Build image with `Build.ps1` script.

Remember to replace `<tag>` with actual tag, i.e.: RavenDB version.

```
& .\Build-Image.ps1 ` 
    -Tag <RavenDB_version> `
    -Latest `
    -PushToDockerHub
```

DockerHub credentials are stored in `credentials` file or can be passed through via parameters.

# FAQ

## I cannot access my RavenDB server website.

Make sure the port you mapped to is open in your firewall settings!

~~There is something wrong with `localhost`, Windows and Docker. I have no idea what can that be.
To get access to RavenDB website, get container IP. Simply type `docker inspect <container_ID>` and look for `Networks.IPAddress`.~~


**Update 11.2017**

According to [this article](https://blogs.technet.microsoft.com/networking/2017/11/06/available-to-windows-10-insiders-today-access-to-published-container-ports-via-localhost127-0-0-1/), from Windows 10 build 17025 `localhost` and `127.0.0.1` should work as expected.


