#!/bin/bash

IMAGE="$1"
ARGS="$2"
OPTS="$3"

docker start autorun-$IMAGE || docker run -d $OPTS -P --name autorun-$IMAGE $IMAGE $ARGS
