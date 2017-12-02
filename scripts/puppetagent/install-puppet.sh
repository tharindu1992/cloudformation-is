#!/usr/bin/env bash
# ----------------------------------------------------------------------------
#
# Copyright (c) 2017, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
#
# WSO2 Inc. licenses this file to you under the Apache License,
# Version 2.0 (the "License"); you may not use this file except
# in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# ----------------------------------------------------------------------------

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

set -e

readonly PUPPET_MASTER=$2

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

echo ">> Sync time with NTP servers ..."
apt-get update
apt-get -y install ntp
service ntp restart

echo ">> Download and install puppet ..."
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb
apt-get update
apt-get -y install puppet
rm puppetlabs-release-trusty.deb
echo ">> Installed puppet version: $(puppet --version)"

echo "> Set puppetmaster host"
echo "$PUPPET_MASTER puppet puppetmaster" >> /etc/hosts
echo "127.0.0.1 $(hostname)" >> /etc/hosts

echo ">> Update puppet.conf"
sed -i '/\[main\]/a server=puppet' /etc/puppet/puppet.conf