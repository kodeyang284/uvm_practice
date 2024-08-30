#!/bin/sh

dockerexec="docker container exec kode bash -c"
dir="/root/Public/uvm_practice"

if [ -n "$1" ]; then
    $dockerexec "make -s -C $dir $1"
else
    $dockerexec "make -s -C $dir run"
fi
