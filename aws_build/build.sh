#!/bin/bash
set -x

GRAFTNODED_DEB_BUILD_DIR="/home/ubuntu/graftnoded"
SUPERGRAFT_DEB_BUILD_DIR="/home/ubuntu/supergraft"
USERNAME="graft"

mkcd(){
  mkdir $1 && cd $1
}

make_build(){
cd /usr/src/
git clone --recursive https://github.com/graft-project/graft-ng.git


mkcd /home/ubuntu/release1

cmake /usr/src/graft-ng
make -j$((`nproc`+1))
}

make_graftnoded_pkg(){

if [[ ! -d "${GRAFTNODED_DEB_BUILD_DIR}" ]]; then
  mkdir ${GRAFTNODED_DEB_BUILD_DIR}
fi

mkdir -p ${GRAFTNODED_DEB_BUILD_DIR}/opt/graft
mkdir -p ${GRAFTNODED_DEB_BUILD_DIR}/etc/systemd/system
mkdir -p ${GRAFTNODED_DEB_BUILD_DIR}/DEBIAN
cp /home/ubuntu/release1/BUILD/cryptonode/bin/{graft-supernode,graft-blockchain-export,graft-blockchain-import,graft-wallet-cli,graft-wallet-rpc,graftnoded} ${GRAFTNODED_DEB_BUILD_DIR}/opt/graft/

cat << EOF > ${GRAFTNODED_DEB_BUILD_DIR}/DEBIAN/control

Source: ng-graft
Section: net
Priority: optional
Maintainer: Vadym Kovalenko <v.kovalenko@triangu.com>
Build-Depends: debhelper (>= 10), cmake, g++, libboost-dev (>= 1.58), libboost-filesystem-dev, libboost-thread-dev, libboost-date-time-dev, libboost-chrono-dev, libboost-regex-dev, libboost-serialization-dev, libboost-program-options-dev, libboost-locale-dev, libunbound-dev (>= 1.4.16), libminiupnpc-dev, libunwind8-dev, libssl-dev, libreadline-dev
Standards-Version: 4.1.2
Homepage: <www.graft.network>
#Vcs-Git: https://anonscm.debian.org/git/collab-maint/ng-graft.git
#Vcs-Browser: https://anonscm.debian.org/cgit/collab-maint/ng-graft.git
Package: graftnoded
Version: 1.0.2
Architecture: amd64
#Recommends: 
#Suggests: 
Description: LEGACY GRAFTNODED PACKAGE
EOF

cat << EOF > ${GRAFTNODED_DEB_BUILD_DIR}/etc/systemd/system/graftnoded.service

[Unit]
Description=Graftnoded Service
After=network.target

[Service]
User=graft
Group=graft
WorkingDirectory=/opt/graft
Type=oneshot
RemainAfterExit=yes
RestartSec=1
ExecStart=/opt/graft/graftnoded --config-file /etc/graftnoded.conf --detach --pidfile /tmp/graftnoded.pid

[Install]
WantedBy=multi-user.target
EOF

cat << EOF > ${GRAFTNODED_DEB_BUILD_DIR}/etc/graft.conf
# Configuration for graftnoded
# Syntax: any command line option may be specified as 'clioptionname=value'.
# See 'graftnoded --help' for all available options.

data-dir=/var/lib/graft
log-file=/var/log/graft/graftnoded.log
log-level=0
EOF

cat << EOF > ${GRAFTNODED_DEB_BUILD_DIR}/DEBIAN/postinst
addgroup -q --system ${USERNAME}
adduser -q --system --home /opt/graft --no-create-home --ingroup ${USERNAME} --disabled-login ${USERNAME}
systemctl daemon-reload
chown -R graft:graft /opt/graft
EOF

chmod 755 ${GRAFTNODED_DEB_BUILD_DIR}/DEBIAN/postinst

cd ${GRAFTNODED_DEB_BUILD_DIR}
dpkg-deb -b ./ ../
}


make_supergraft_pkg(){

if [[ ! -d "${SUPERGRAFT_DEB_BUILD_DIR}" ]]; then
  mkdir ${SUPERGRAFT_DEB_BUILD_DIR}
fi

mkdir -p ${SUPERGRAFT_DEB_BUILD_DIR}/opt/graft/supernode.d
mkdir -p ${SUPERGRAFT_DEB_BUILD_DIR}/etc/graft
mkdir -p ${SUPERGRAFT_DEB_BUILD_DIR}/etc/systemd/system
mkdir -p ${SUPERGRAFT_DEB_BUILD_DIR}/DEBIAN

cp /home/ubuntu/release1/supernode  ${SUPERGRAFT_DEB_BUILD_DIR}/opt/graft
cp /home/ubuntu/release1/config.ini  ${SUPERGRAFT_DEB_BUILD_DIR}/etc/graft/supernode-config.ini

cp  /home/ubuntu/release1/graftlets/supernode/libgraftlet_walletAddress.so ${SUPERGRAFT_DEB_BUILD_DIR}/opt/graft/supernode.d/

cat << EOF > ${SUPERGRAFT_DEB_BUILD_DIR}/DEBIAN/control

Source: ng-graft
Section: net
Priority: optional
Maintainer: Vadym Kovalenko <v.kovalenko@triangu.com>
Build-Depends: debhelper (>= 10), cmake, g++, libboost-dev (>= 1.58), libboost-filesystem-dev, libboost-thread-dev, libboost-date-time-dev, libboost-chrono-dev, libboost-regex-dev, libboost-serialization-dev, libboost-program-options-dev, libboost-locale-dev, libunbound-dev (>= 1.4.16), libminiupnpc-dev, libunwind8-dev, libssl-dev, libreadline-dev
Standards-Version: 4.1.2
Homepage: <www.graft.network>
#Vcs-Git: https://anonscm.debian.org/git/collab-maint/ng-graft.git
#Vcs-Browser: https://anonscm.debian.org/cgit/collab-maint/ng-graft.git
Package: supergraft
Depends: graftnoded
Version: 1.0.2
Architecture: amd64
#Recommends: 
#Suggests: 
Description: LEGACY SUPERGRAFT PACKAGE
EOF


cat << EOF > ${SUPERGRAFT_DEB_BUILD_DIR}/etc/systemd/system/graft-supernode-legacy.service
[Unit]
Description=Supergraft Service
After=network.target

[Service]
User=graft
Group=graft
WorkingDirectory=/opt/graft

Type=oneshot
PIDFile=/tmp/supernode.pid
KillMode=process

ExecStart=/opt/graft/supernode --config-file /etc/graft/supernode-config.ini 

[Install]
WantedBy=multi-user.target
EOF

cat << EOF > ${SUPERGRAFT_DEB_BUILD_DIR}/DEBIAN/postinst
systemctl daemon-reload
chown -R graft:graft /opt/graft/supernode
chown -R graft:graft /etc/graft
EOF

chmod 755 ${SUPERGRAFT_DEB_BUILD_DIR}/DEBIAN/postinst

cd ${SUPERGRAFT_DEB_BUILD_DIR}
dpkg-deb -b ./ ../
}

#make_build

#make_graftnoded_pkg

make_supergraft_pkg
