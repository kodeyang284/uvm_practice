#!/bin/sh

if ! systemctl is-active docker 2>&1 >/dev/null; then
  systemctl start docker 
fi

if docker ps --all | grep kode 2>&1 >/dev/null; then
  docker container start kode && \
    $HOME/Public/uvm_practice/script/fixhosts.sh
  echo "---- container now runing --------"
else
  echo "try to create a container named kode"
  docker run -it --name kode -p 5902:5902 \
  --hostname lizhen \
  --mac-address 02:42:ac:11:00:02 \
  -v ~/Public:/root/Public phyzli/ubuntu18.04_xfce4_vnc4server_synopsys:latest
fi
