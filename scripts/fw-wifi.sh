#!/bin/bash
# List existing direct rules to double-check
sudo firewall-cmd --direct --get-all-rules

# Remove the existing direct rules one by one
# sudo firewall-cmd --permanent --direct --remove-rule ipv4 filter FORWARD 0 -i virbr0 -o wlp0s20f3 -j ACCEPT
# sudo firewall-cmd --permanent --direct --remove-rule ipv4 filter FORWARD 1 -i wlp0s20f3 -o virbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT
# sudo firewall-cmd --permanent --direct --remove-rule ipv4 filter FORWARD 0 -i virbr0 -o enp0s13f0u2u4u4 -j ACCEPT
# sudo firewall-cmd --permanent --direct --remove-rule ipv4 filter FORWARD 1 -i enp0s13f0u2u4u4 -o virbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT
# sudo firewall-cmd --permanent --direct --remove-rule ipv4 filter FORWARD 0 -i enp0s13f0u2u4u4 -o virbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT
# sudo firewall-cmd --permanent --direct --remove-rule ipv4 filter FORWARD 0 -i wlp0s20f3 -o virbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT
# sudo firewall-cmd --permanent --direct --remove-rule ipv4 nat POSTROUTING 0 -s 192.168.122.0/24 -o wlp0s20f3 -j MASQUERADE
# sudo firewall-cmd --permanent --direct --remove-rule ipv4 nat POSTROUTING 0 -s 192.168.122.0/24 -o enp0s13f0u2u4u4 -j MASQUERADE

# Add the correct rules for your active interface
sudo firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -i virbr0 -o enp0s13f0u2u4u4 -j ACCEPT
sudo firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 1 -i enp0s13f0u2u4u4 -o virbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -s 192.168.122.0/24 -o enp0s13f0u2u4u4 -j MASQUERADE

# Reload firewall
sudo firewall-cmd --reload
