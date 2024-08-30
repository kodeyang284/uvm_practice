#!/bin/sh

dockerexec="docker container exec kode bash -c"

$dockerexec 'cat /root/Public/uvm_practice/script/hosts >> /etc/hosts' && \
$dockerexec "cp /etc/resolv.conf ~/resolv.conf.new &&
             sed -i 's/^/#/g' ~/resolv.conf.new &&
             cp -f ~/resolv.conf.new /etc/resolv.conf"
