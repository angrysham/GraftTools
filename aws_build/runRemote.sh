#!/bin/bash

key_file="graft.key"

REMOTE1="$(aws ec2 describe-spot-instance-requests |grep InstanceId|awk -F'\"' '{print $4}')"
REMOTE2="$(aws ec2 describe-instances --instance-id ${REMOTE1} |grep PublicIpAddress|awk -F'\"' '{print $4}')"
echo $REMOTE2

#runRemote build.sh


runRemote() {
  local args script

  script=$1; shift

  # generate eval-safe quoted version of current argument list
  printf -v args '%q ' "$@"

  # pass that through on the command line to bash -s
  # note that $args is parsed remotely by /bin/sh, not by bash!
  ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${key_file}  ubuntu@${REMOTE2} "sudo bash -s -- $args" < "$script"
}


runRemote build.sh
