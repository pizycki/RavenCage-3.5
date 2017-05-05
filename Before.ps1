$env:DOCKER_REPOSITORY = "pizycki/test"
$env:IS_LATEST = "true"
$env:APPVEYOR_REPO_TAG = "true"
$env:APPVEYOR_REPO_TAG_NAME = "testo"
$env:PUSH_TO_DOCKERHUB = "true"

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q) --force
docker ps 
docker images