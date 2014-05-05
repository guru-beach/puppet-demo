#!/bin/bash
# bootstrap.sh
# PURPOSE: Bootstrap a node to allow it to run puppet manifests
#          This will install all resources in a users home directory
# AUTHORS: Jake Lundberg <code@guru-beach.com>

# Install git tools
sudo yum install -y git
# Clone the puppet-demo repo
if [ ! -d "puppet-demo" ];then
  git clone https://github.com/guru-beach/puppet-demo.git
fi
cd puppet-demo
# Install the yum repo for puppet
if [ ! -f "/etc/yum.repos.d/puppet-labs.repo" ]; then
  sudo cp puppet-labs.repo /etc/yum.repos.d/
fi
# Install the puppet packages.  Hiera isn't being used, but install it anyway
sudo yum install -y puppet hiera facter


# Make the magic happen
sudo puppet apply manifests/site.pp --modulepath=${PWD}/modules

# And the moment we've all been waiting for:
curl -s http://localhost:8000/
