#!/bin/bash

DEB_BUILD_DIR="/home/ubuntu/debian"

cd /usr/src/
git clone --recursive https://github.com/graft-project/graft-ng.git

mkcd(){
  mkdir $1 && cd $1
}

mkcd /home/ubuntu/release1

cmake /usr/src/graft-ng
make -j 4

mkdir -p ${DEB_BUILD_DIR}/usr/bin
mkdir -p ${DEB_BUILD_DIR}/DEBIAN
cp /home/ubuntu/release1/BUILD/bin/{graft-supernode,graft-wallet-cli,graft-wallet-rpc,graftnoded} ${DEB_BUILD_DIR}
cp /home/ubuntu/release1/supernode  ${DEB_BUILD_DIR} 

cat << EOF > ${DEB_BUILD_DIR}/DEBIAN/control

Source: ng-graft
Section: net
Priority: optional
Maintainer: Vadym Kovalenko <v.kovalenko@triangu.com>
Build-Depends: debhelper (>= 10), cmake, g++, libboost-dev (>= 1.58), libboost-filesystem-dev, libboost-thread-dev, libboost-date-time-dev, libboost-chrono-dev, libboost-regex-dev, libboost-serialization-dev, libboost-program-options-dev, libboost-locale-dev, libunbound-dev (>= 1.4.16), libminiupnpc-dev, libunwind8-dev, libssl-dev, libreadline-dev
Standards-Version: 4.1.2
Homepage: <www.graft.network>
#Vcs-Git: https://anonscm.debian.org/git/collab-maint/ng-graft.git
#Vcs-Browser: https://anonscm.debian.org/cgit/collab-maint/ng-graft.git
Package: graft-supernode
Version: 1.0.1
Architecture: amd64
#Recommends: 
#Suggests: 
Description: GRAFT RTA supernode
EOF

cd ${DEB_BUILD_DIR}
dpkg-deb -b ./ ../



