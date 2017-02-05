# Copyright 2015 Google Inc. All Rights Reserved.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# exit on exception
set -e

# set up golang
wget -q https://storage.googleapis.com/golang/go1.7.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.7.5.linux-amd64.tar.gz
sudo ln -s /usr/local/go/bin/go /usr/local/bin/go
sudo ln -s /usr/local/go/bin/godoc /usr/local/bin/godoc
sudo ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt

# configure hyperspace (previously downloaded in scripts/base.sh)
cd /srv/hyperspace/hyperspace
sudo -u hyperspace GOPATH=$(pwd) go get github.com/gorilla/websocket
sudo -u hyperspace GOPATH=$(pwd) go get github.com/lucasb-eyer/go-colorful
sudo -u hyperspace GOPATH=$(pwd) make
sudo killall server

# make sure hyperspace starts on reboot
sudo touch /var/log/hyperspace.log
sudo chmod 755 /var/log/hyperspace.log

# configure hyperspace (previously downloaded with scripts/base.sh)
cd /srv/hyperspace/hyperspace
sudo -u hyperspace sed -i '3d' etc/nginx.conf
sudo -u hyperspace sed -i '28,33d' etc/nginx.conf

# install nginx
sudo apt-get install -y nginx
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /srv/hyperspace/hyperspace/etc/nginx.conf /etc/nginx/sites-enabled/default
sudo ln -s /srv/hyperspace/hyperspace/etc/hyperspace.service /etc/systemd/system/multi-user.target.wants/
