# -*- mode: ruby -*-
# vi: set ft=ruby :
# Copyright 2017 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Usage:
#   $ vagrant up --provider=google
#   $ vagrant destroy

# Customize these global variables
$GOOGLE_PROJECT_ID = "modern-girder-157718"
$GOOGLE_CLIENT_EMAIL = "hashicorp-videos@modern-girder-157718.iam.gserviceaccount.com"
$GOOGLE_JSON_KEY_LOCATION = "/Users/erjohnso/hashicorp-videos.json"
$LOCAL_USER = "erjohnso"
$LOCAL_SSH_KEY = "~/.ssh/google_compute_engine"

Vagrant.configure("2") do |config|

  config.vm.box = "google/gce"
  config.vm.provider :google do |google, override|
    google.google_project_id = $GOOGLE_PROJECT_ID
    google.google_client_email = $GOOGLE_CLIENT_EMAIL
    google.google_json_key_location = $GOOGLE_JSON_KEY_LOCATION

    # Override provider defaults
    google.name = "hyperspace-dev"
    google.image = "ubuntu-1604-xenial-v20170125"
    google.machine_type = "g1-small"
    google.zone = "us-central1-f"
    google.tags = ['hyperspace', 'dev', 'http-server']
    override.ssh.username = $LOCAL_USER
    override.ssh.private_key_path = $LOCAL_SSH_KEY
  end

  # set up folder sync
  config.vm.synced_folder "~/src/hyperspace", "/srv/hyperspace"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # https://github.com/mitchellh/vagrant/issues/1673
  config.vm.provision "fix-no-tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  # set up initial env
  config.vm.provision "shell", inline: $script

end

# provisioning script
$script = <<SCRIPT
DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install build-essential nginx -y

rm /etc/nginx/sites-enabled/default
ln -s /srv/hyperspace/etc/nginx.conf /etc/nginx/sites-enabled/default
ln -s /srv/hyperspace/etc/hyperspace.service /etc/systemd/system/

wget -q https://storage.googleapis.com/golang/go1.7.5.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.7.5.linux-amd64.tar.gz
ln -s /usr/local/go/bin/go /usr/local/bin/go
ln -s /usr/local/go/bin/godoc /usr/local/bin/godoc
ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt

cd /srv/hyperspace
export GOPATH=$(pwd)
sed -i '3d' etc/nginx.conf
sed -i '28,33d' etc/nginx.conf
go get github.com/gorilla/websocket
go get github.com/lucasb-eyer/go-colorful
cd server;  go build
systemctl restart nginx
systemctl start hyperspace
SCRIPT

