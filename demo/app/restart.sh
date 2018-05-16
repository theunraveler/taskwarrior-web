#!/bin/ash

cd $(dirname $(realpath $0))

cp -f ./data/.taskrc /root/
cp -rf ./data/.task /root/

echo $(date +"%Y-%m-%d %H:%M:%S") Taskwarrior database resetted > /var/log/reset.log