#!/bin/sh

MILESTONE=$1

cd ~

[ ! -d "devstack" ] && {

  # Gets Devstack on Github
  sudo apt-get install -qqy git 
  git clone https://github.com/openstack-dev/devstack.git
  cd devstack
  
  [ -n "${MILESTONE}" ] && git checkout stable/$MILESTONE
  
  cat > localrc <<EOL
ADMIN_PASSWORD=devstack
MYSQL_PASSWORD=devstack
RABBIT_PASSWORD=devstack
SERVICE_PASSWORD=devstack
SERVICE_TOKEN=devstack

# Set the public interface on eth1 as created by Vagrant
FLAT_INTERFACE=br100
PUBLIC_INTERFACE=eth1
 
VOLUME_BACKING_FILE_SIZE=5120M
 
enable_service swift
 
SWIFT_HASH=66a3d6b56c1f479c8b4e71ab5c2000f6
EOL
  
  [ -n "${MILESTONE}" ] && {
  
    cat >> localrc <<EOL
    
# For older, stable versions, look for branches named stable/[milestone].
 
# compute service
NOVA_BRANCH=stable/${MILESTONE}
 
# volume service
CINDER_BRANCH=stable/${MILESTONE}
 
# image catalog service
GLANCE_BRANCH=stable/${MILESTONE}
 
# unified auth system (manages accounts/tokens)
KEYSTONE_BRANCH=stable/${MILESTONE}
 
# quantum service
QUANTUM_BRANCH=stable/${MILESTONE}
 
# django powered web control panel for openstack
HORIZON_BRANCH=stable/${MILESTONE}
 
# object storage
SWIFT_BRANCH=stable/${MILESTONE}
EOL
  }
  
  ./stack.sh

}
