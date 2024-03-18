#!/bin/sh

dockerexec="docker container exec kode bash -c"
dir="/root/Public/uvm_practice"

if [ -n "$1" ]; then
    $dockerexec "cd $dir && make $1"
else
    $dockerexec "cd $dir && make"
fi
