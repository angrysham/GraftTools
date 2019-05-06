#!/bin/bash

GRAFTNODE_DEB_BUILD_DIR="/home/ubuntu/graftnoded"
SUPERNODE_DEB_BUILD_DIR="/home/ubuntu/supernode"
USERNAME="graft"
GROUP="graft"
PRJ_SOURCE=$HOME/graft
RELEASE_FOLDER="$HOME/release1"
GLOBAL_CONFIG="/etc/default/graft"
DEFAULT_NETWORK="mainnet"

make_supernode_pkg(){

if [[ ! -d "${SUPERNODE_DEB_BUILD_DIR}" ]]; then
  mkdir ${SUPERNODE_DEB_BUILD_DIR}
fi

mkdir -p ${SUPERNODE_DEB_BUILD_DIR}/opt/graft/supernode.d
mkdir -p ${SUPERNODE_DEB_BUILD_DIR}/etc/graft
mkdir -p ${SUPERNODE_DEB_BUILD_DIR}/etc/default
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
Version: 1.0.8
Architecture: amd64
#Recommends: 
#Suggests: 
Description: LEGACY SUPERNODE PACKAGE
EOF


cat << EOF > ${SUPERNODE_DEB_BUILD_DIR}/etc/systemd/system/graft-supernode.service
[Unit]
Description=Supergraft Service
After=network.target graftnode.service

[Service]
User=graft
Group=graft
WorkingDirectory=/opt/graft

Type=simple
PIDFile=/tmp/supernode.pid
KillMode=process

ExecStart=/opt/graft/supernode --config-file /etc/graft/supernode-config.ini

[Install]
WantedBy=multi-user.target
EOF

cat << EOF > ${SUPERNODE_DEB_BUILD_DIR}/DEBIAN/postinst

#!/bin/bash

if [ -f ${GLOBAL_CONFIG} ]; then
	GRAFT_NETWORK="$(cat ${GLOBAL_CONFIG}| grep GRAFT_NETWORK |  awk -F'=' '{print $2}')"
	sed -i -e 's/wallet-public-address=/wallet-public-address=\${GRAFT_NETWORK}/g' /etc/graft/supernode-config.ini
	sed -i -e 's/:\/var\/opt/:\/opt\/graft\/supernode.d/g' /etc/graft/supernode-config.ini
fi

chown -R ${USERNAME}:${GROUP} /opt/graft/supernode
chown -R ${USERNAME}:${GROUP} /etc/graft
systemctl daemon-reload
systemctl enable graft-supernode
systemctl start graft-supernode
EOF

cat << EOF > ${SUPERNODE_DEB_BUILD_DIR}/etc/default/graft
GRAFT_NETWORK=\${DEFAULT_NETWORK}
EOF

cat << EOF > ${SUPERNODE_DEB_BUILD_DIR}/DEBIAN/postrm
#!/bin/bash
systemctl stop graft-supernod
systemctl disable graft-supernode
systemctl daemon-reload
EOF

chmod 755 ${SUPERNODE_DEB_BUILD_DIR}/DEBIAN/postinst
chmod 755 ${SUPERNODE_DEB_BUILD_DIR}/DEBIAN/postrm

cd ${SUPERNODE_DEB_BUILD_DIR}

dpkg-deb -b ./ ../

}

make_supernode_pkg
