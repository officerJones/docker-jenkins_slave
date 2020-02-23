Docker jenkins_slave image
===
[![Build Status](https://travis-ci.org/officerJones/docker-jenkins_slave.svg?branch=master)](https://travis-ci.org/officerJones/docker-jenkins_slave)  
An image to use as a slave for Jenkins preloaded with test-tools.
## Usage
Configure your Jenkins master to use this image.
## Build
The image is built for arm architecture on a Raspberry Pi 3 B+.
You can build on your own platform using the Dockerfile for other architectures.
```sh
	docker build --tag <yourtag:yourversion> .
```