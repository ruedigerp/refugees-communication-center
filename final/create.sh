#!/bin/bash

echo "Images: "
docker images | grep refugees | egrep -v "pc|base" | awk {'print $1'} | awk -F"/" {'print $2'}

echo -n "From: " 
read FROM

echo -n "Password: " 
read PASSWORD

echo -n "PC Number: " 
read DEST

sed -e "s/@@FROM@@/$FROM/" Dockerfile.tpl > Dockerfile
sed -i -e "s/@@PASSWORD@@/$PASSWORD/" Dockerfile
rm Dockerfile-e 

docker build -t refugees/pc${DEST} .
docker run -d -p 1590${DEST}:5900 --name pc${DEST} refugees/pc${DEST}
docker port pc${DEST}


