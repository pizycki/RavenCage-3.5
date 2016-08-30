FROM microsoft/windowsservercore
MAINTAINER pizycki 

EXPOSE 8080 

# Download RavenDB server package from official build website
ADD http://hibernatingrhinos.com/downloads/RavenDB/35166-RC C:/RavenDB_Server.zip
COPY ExtractRavenDB.ps1 .
RUN ["powershell", "-File", "ExtractRavenDB.ps1"]

WORKDIR C:/RavenDB/Server
ENTRYPOINT ["powershell", ".\\Raven.Server.exe --debug"]