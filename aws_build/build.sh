#!/bin/bash

GRAFTNODE_DEB_BUILD_DIR="/home/ubuntu/graftnoded"
SUPERNODE_DEB_BUILD_DIR="/home/ubuntu/supernode"
USERNAME="graft"
GROUP="graft"
PRJ_SOURCE=$HOME/graft
RELEASE_FOLDER="$HOME/release1"
GLOBAL_CONFIG="/etc/default/graft"

mkcd(){
  mkdir $1 && cd $1
}

make_build(){
        [ ! -d "${PRJ_SOURCE}" ] && echo "Creating folder for prj source" && mkdir ${PRJ_SOURCE}
	cd ${PRJ_SOURCE}
	git clone --recursive https://github.com/graft-project/graft-ng.git
	mkcd ${RELEASE_FOLDER}
	cmake ${PRJ_SOURCE}/graft-ng
	make -j$((`nproc`+1))
}

make_build

echo -e  "Usage $0 make_build \n\t make_build --- performs project compilation \n\t make_graftnode_pkg --- performs graftnode package build \n\t make_supernode_pkg --- performs supernode package build"
