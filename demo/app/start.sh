#!/bin/sh

cd $(dirname $(realpath $0))

mkdir -p /root/.task

./restart.sh && task && task-web -p 80 -L -F