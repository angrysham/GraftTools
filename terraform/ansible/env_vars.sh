#!/bin/bash
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export EC2_INSTANCE_FILTERS="tag:Environment=sandbox1"
export ANSIBLE_HOSTS=./ec2.py
export ANSIBLE_CONFIG=./ansible.cfg
