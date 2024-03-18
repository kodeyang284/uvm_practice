#!/bin/sh

dockerexec="docker container exec kode bash -c"

$dockerexec 'cat /root/Public/uvm_practice/script/hosts >> /etc/hosts' && \
$dockerexec 'rm -f /etc/resolv.conf'
