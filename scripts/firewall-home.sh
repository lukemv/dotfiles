#!/bin/bash
set -euo pipefail

# Remove work-specific rules
sudo firewall-cmd --permanent --direct --remove-rule ipv4 filter FORWARD 0 -i virbr0 -o enp0s13f0u2u4u4 -j ACCEPT || true
sudo firewall-cmd --permanent --direct --remove-rule ipv4 filter FORWARD 1 -i enp0s13f0u2u4u4 -o virbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT || true
sudo firewall-cmd --permanent --direct --remove-rule ipv4 nat POSTROUTING 0 -s 192.168.122.0/24 -o enp0s13f0u2u4u4 -j MASQUERADE || true

# Add home-specific rules
sudo firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -i virbr0 -o wlp0s20f3 -j ACCEPT
sudo firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 1 -i wlp0s20f3 -o virbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -s 192.168.122.0/24 -o wlp0s20f3 -j MASQUERADE

# Apply changes
sudo firewall-cmd --reload
echo "✅ Firewall rules set for HOME (Wi-Fi: wlp0s20f3)"


