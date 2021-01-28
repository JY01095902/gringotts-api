#! /bin/bash

source env.loc.sh

export GRINGOTTS_MONGO_IP="localhost"

# docker stop t2hut-gringotts-api-dev
# docker rm t2hut-gringotts-api-dev

go run .