#!/bin/bash

BASENAME=`basename $(pwd)`
CHECK=`docker images refugees/${BASENAME} | wc -l `
# echo "Check: $CHECK"

if [ `docker images refugees/${BASENAME} | wc -l ` -eq 2 ]
then
	docker rmi refugees/`basename $(pwd)`
fi

docker build -t refugees/`basename $(pwd)` .

