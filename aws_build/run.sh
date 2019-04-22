#!/bin/bash

export KEY_FILE=${KEY_FILE}

REMOTE_HOST="$(aws ec2 describe-spot-instance-requests |grep InstanceId|awk -F'\"' '{print $4}')"
REMOTE_IP="$(aws ec2 describe-instances --instance-id ${REMOTE_HOST} |grep PublicIpAddress|awk -F'\"' '{print $4}')"

runLocal(){
  ./build.sh
}

runRemote(){
  local args script

  script=$1; shift

  # generate eval-safe quoted version of current argument list
  printf -v args '%q ' "$@"

  # pass that through on the command line to bash -s
  # note that $args is parsed remotely by /bin/sh, not by bash!
  ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${key_file}  ubuntu@${REMOTE_IP} "sudo bash -s -- $args" < "$script"
}
case $1 in
        local)
	  runLocal	
	;;
	remote)
 	  runRemote build.sh
	;;
	*)
	echo "$0 usage: local|remote"
	;;
esac	

