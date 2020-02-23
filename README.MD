Docker minidlna image
===
[![Build Status](https://travis-ci.org/officerJones/docker-minidlna.svg?branch=master)](https://travis-ci.org/officerJones/docker-minidlna)  
An image to run a minidlna server from within docker.
## Usage
### Docker-compose
1. Set host volume in docker-compose.yml as desired.
2. Set host ip in healthcheck of docker-compose.yml as desired.
3. Run docker-compose 
```sh
	docker-compose up -d
```
### Docker
1. Run docker with volume and host  
```sh
	docker run -v </your/movie/path>:mnt/media/movies --net=host --name minidlna -p 8200:8200 officerjones/minidlna
```
## Build
The image is built for arm architecture on a Raspberry Pi 3 B+.
You can build on your own platform using the Dockerfile for other architectures.
```sh
	docker build --tag <yourtag:yourversion> .
```