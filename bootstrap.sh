#!/bin/bash
# bootstrap.sh
# PURPOSE: Bootstrap a node to allow it to run puppet manifests
#          This will install all resources in a users home directory
# AUTHORS: Jake Lundberg <code@guru-beach.com>

#Install git tools
sudo yum install -y git-all
#Clone the puppet-demo repo
if [ ! -d "puppet-demo" ];then
  git clone https://github.com/guru-beach/puppet-demo.git
fi
cd puppet-demo
if [ ! -f "/etc/yum.repos.d/puppet-labs.repo" ]; then
  cp puppet-labs.repo /etc/yum.repos.d/
fi
sudo yum install -y puppet hiera facter


#Clone puppet-demo repo
sudo puppet apply manifests/site.pp
