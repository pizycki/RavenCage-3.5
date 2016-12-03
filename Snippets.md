**How to remove old Docker containers**
```
docker rm $(docker ps -q -f status=exited)
```

**Remove all images**
```
docker rmi $(docker images -q) 
```

**Remove last builded image (be carefull with this one)**
```
docker rmi (docker images -q)[0] -f; docker images
```

**Get running containers IP**
```
docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" <container_id>
```
