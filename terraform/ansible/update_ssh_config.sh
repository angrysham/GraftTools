#!/bin/bash
set -x

public_IP="$(aws ec2 describe-instances --filters "Name=tag:Name,Values=sandbox1-bastion" --output=json | jq -r '.Reservations[].Instances[].NetworkInterfaces[].Association.PublicIp')"

sed -e "/ProxyJump Proxy_var/c\  ProxyJump ${public_IP}" -e "s/Host Proxy_var/Host ${public_IP}/g" ssh_config_template > ssh_config
