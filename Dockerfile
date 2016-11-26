FROM microsoft/windowsservercore
MAINTAINER pizycki

EXPOSE 8080

# Default mode server runs.
ENV mode=background

# Download RavenDB server package from official build website
ADD http://hibernatingrhinos.com/downloads/RavenDB/35181 C:/RavenDB_Server.zip
COPY Run-RavenDB.ps1 .
CMD powershell ./Run-RavenDB.ps1 -Verbose