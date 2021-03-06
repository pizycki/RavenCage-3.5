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

[Automated builds](https://ci.appveyor.com/project/pizycki/ravencage-3-5) are initialized on every **tagged** commit. 

Thanks to [AppVeyor](http://appyveyor.com) for letting use their platform! **You are the real MVP!**

### Manual
Build image with `Build.ps1` script.

Remember to replace `<tag>` with actual tag name, i.e.: RavenDB version.

```
& .\Build-Image.ps1 ` 
    -Tag <RavenDB_version> `
    -Latest `
    -PushToDockerHub
```

DockerHub credentials are stored in `credentials` file or can be passed through via parameters.

## Not up to date?
Starting from January 2018 this image will be updated **on request only**.

If you see that new RavenDB version is out and you'd like to get it from `pizycki/ravendb`, create an issue or tweet me!
