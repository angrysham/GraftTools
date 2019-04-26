#!/bin/bash

key_file="graft.key"

REMOTE_HOST="$(aws ec2 describe-spot-instance-requests --output=text |grep active |awk -F' ' '{print $3}')"
REMOTE_IP="$(aws ec2 describe-instances --instance-id ${REMOTE_HOST} |grep PublicIpAddress|awk -F'\"' '{print $4}')"

runRemote() {
  local args script

  script=$1; shift

  # generate eval-safe quoted version of current argument list
  printf -v args '%q ' "$@"

  # pass that through on the command line to bash -s
  # note that $args is parsed remotely by /bin/sh, not by bash!
  env| grep UPLOAD > file1 && scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${key_file}  file1 ubuntu@${REMOTE_IP}:~/.bash_env && rm file1
  ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${key_file}  ubuntu@${REMOTE_IP} "sudo bash -s --$args" < "$script"
}


runRemote $1
