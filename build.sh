#! /bin/bash

CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build .

docker build --force-rm -t t2hut-gringotts-api .
