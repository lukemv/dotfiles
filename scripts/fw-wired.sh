#!/bin/bash
sudo firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -i virbr0 -o enp0s13f0u2u4u4 -j ACCEPT
sudo firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -i enp0s13f0u2u4u4 -o virbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -s 192.168.122.0/24 -o enp0s13f0u2u4u4 -j MASQUERADE

sudo firewall-cmd --reload

