#!/bin/bash

docker stop pc$1
docker rm pc$1
docker rmi refugees/pc$1

