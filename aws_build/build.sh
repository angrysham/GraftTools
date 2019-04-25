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

make_graftnode_pkg(){

if [[ ! -d "${GRAFTNODE_DEB_BUILD_DIR}" ]]; then
  mkdir ${GRAFTNODE_DEB_BUILD_DIR}
fi

mkdir -p ${GRAFTNODE_DEB_BUILD_DIR}/opt/graft
mkdir -p ${GRAFTNODE_DEB_BUILD_DIR}/etc/systemd/system
mkdir -p ${GRAFTNODE_DEB_BUILD_DIR}/DEBIAN
cp ${RELEASE_FOLDER}/BUILD/cryptonode/bin/{graft-supernode,graft-blockchain-export,graft-blockchain-import,graft-wallet-cli,graft-wallet-rpc,graftnoded} ${GRAFTNODE_DEB_BUILD_DIR}/opt/graft/

cat << EOF > ${GRAFTNODE_DEB_BUILD_DIR}/DEBIAN/control

Source: ng-graft
Section: net
Priority: optional
Maintainer: Vadym Kovalenko <v.kovalenko@triangu.com>
Build-Depends: debhelper (>= 10), cmake, g++, libboost-dev (>= 1.58), libboost-filesystem-dev, libboost-thread-dev, libboost-date-time-dev, libboost-chrono-dev, libboost-regex-dev, libboost-serialization-dev, libboost-program-options-dev, libboost-locale-dev, libunbound-dev (>= 1.4.16), libminiupnpc-dev, libunwind8-dev, libssl-dev, libreadline-dev
Standards-Version: 4.1.2
Homepage: <www.graft.network>
#Vcs-Git: https://anonscm.debian.org/git/collab-maint/ng-graft.git
#Vcs-Browser: https://anonscm.debian.org/cgit/collab-maint/ng-graft.git
Package: graftnode
Version: 1.0.3
Architecture: amd64
#Recommends: 
#Suggests: 
Description: LEGACY GRAFTNODE PACKAGE
EOF

cat << EOF > ${GRAFTNODE_DEB_BUILD_DIR}/etc/systemd/system/graftnode.service

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
ExecStart=/opt/graft/graftnoded --config-file /etc/graftnode.conf --detach --pidfile /tmp/graftnoded.pid

[Install]
WantedBy=multi-user.target
EOF

cat << EOF > ${GRAFTNODE_DEB_BUILD_DIR}/etc/graftnode.conf
  # Configuration for graftnoded
  # Syntax: any command line option may be specified as 'clioptionname=value'.
  # See 'graftnode --help' for all available options.

  data-dir=/var/lib/graft
  log-file=/var/log/graft/graftnode.log
  log-level=0
EOF

cat << EOF > ${GRAFTNODE_DEB_BUILD_DIR}/DEBIAN/postinst
  addgroup -q --system ${GROUP}
  adduser -q --system --home /opt/graft --no-create-home --ingroup ${USERNAME} --disabled-login ${USERNAME}
  systemctl daemon-reload
  chown -R ${USERNAME}:${GROUP} /opt/graft
  systemctl enable graftnode
  systemctl start graftnode
EOF

cat<< EOF > ${GRAFTNODE_DEB_BUILD_DIR}/DEBIAN/postrm
 systemctl stop graftnode
 systemctl daemon-reload
EOF

chmod 755 ${GRAFTNODE_DEB_BUILD_DIR}/DEBIAN/postinst
chmod 755 ${GRAFTNODE_DEB_BUILD_DIR}/DEBIAN/postrm

cd ${GRAFTNODE_DEB_BUILD_DIR}
dpkg-deb -b ./ ../
}


make_supernode_pkg(){

if [[ ! -d "${SUPERNODE_DEB_BUILD_DIR}" ]]; then
  mkdir ${SUPERNODE_DEB_BUILD_DIR}
fi

mkdir -p ${SUPERNODE_DEB_BUILD_DIR}/opt/graft/supernode.d
mkdir -p ${SUPERNODE_DEB_BUILD_DIR}/etc/graft
mkdir -p ${SUPERNODE_DEB_BUILD_DIR}/etc/systemd/system
mkdir -p ${SUPERNODE_DEB_BUILD_DIR}/DEBIAN

cp /home/ubuntu/release1/supernode  ${SUPERNODE_DEB_BUILD_DIR}/opt/graft
cp /home/ubuntu/release1/config.ini  ${SUPERNODE_DEB_BUILD_DIR}/etc/graft/supernode-config.ini

cp  /home/ubuntu/release1/graftlets/supernode/libgraftlet_walletAddress.so ${SUPERNODE_DEB_BUILD_DIR}/opt/graft/supernode.d/

cat << EOF > ${SUPERNODE_DEB_BUILD_DIR}/DEBIAN/control

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
Depends: graftnode
Version: 1.0.3
Architecture: amd64
#Recommends: 
#Suggests: 
Description: LEGACY SUPERNODE PACKAGE
EOF


cat << EOF > ${SUPERNODE_DEB_BUILD_DIR}/etc/systemd/system/graft-supernode-legacy.service
[Unit]
Description=Supergraft Service
After=network.target graftnode.service

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

cat << EOF > ${SUPERNODE_DEB_BUILD_DIR}/DEBIAN/postinst

if [ -f ${GLOBAL_CONFIG} ]; then
  GRAFTNET=`grep GRAFT_NETWORK ${GLOBAL_CONFIG} | awk -F'=' '{print $2}'`
fi

perl -pi -e  's/wallet-public-address=/wallet-public-address='${GRAFTNET}'/g' /etc/graft/supernode-config.ini 
systemctl daemon-reload
chown -R ${USERNAME}:${GROUP} /opt/graft/supernode
chown -R ${USERNAME}:${GROUP} /etc/graft
EOF

chmod 755 ${SUPERNODE_DEB_BUILD_DIR}/DEBIAN/postinst

cd ${SUPERNODE_DEB_BUILD_DIR}
dpkg-deb -b ./ ../

}

#make_build

#make_graftnode_pkg

make_supernode_pkg

echo -e  "Usage $0 make_build | make_graftnode_pkg | make_supernode_pkg \n\t make_build --- performs project compilation \n\t make_graftnode_pkg --- performs graftnode package build \n\t make_supernode_pkg --- performs supernode package build"
