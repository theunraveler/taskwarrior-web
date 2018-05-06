#!/bin/ash

cd $(dirname $(realpath $0))

cp -f ./data/.taskrc /root/
cp -rf ./data/.task /root/