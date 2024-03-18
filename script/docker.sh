#!/bin/sh

if ! systemctl is-active docker; then
  systemctl start docker 
fi

docker container start kode && \
. $HOME/Public/uvm_practice/script/fixhosts.sh

#docker run -it --name kode -p 5902:5902 --hostname lizhen --mac-address 02:42:ac:11:00:02 -v ~/Public:/root/Public phyzli/ubuntu18.04_xfce4_vnc4server_synopsys:latest
