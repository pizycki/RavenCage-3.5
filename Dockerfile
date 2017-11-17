FROM microsoft/windowsservercore
MAINTAINER pizycki

EXPOSE 8080

# Default mode server runs.
ENV mode=background

# Download RavenDB server package from official build website
ADD http://hibernatingrhinos.com/downloads/RavenDB/35237-Patch C:/RavenDB_Server.zip

COPY Extract-RavenDB.ps1 Run-RavenDB.ps1 ./
SHELL ["powershell", "-command"]
RUN ./Extract-RavenDB.ps1
CMD ./Run-RavenDB.ps1
