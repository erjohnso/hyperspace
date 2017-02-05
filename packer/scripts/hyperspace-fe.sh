# Copyright 2015 Google Inc. All Rights Reserved.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# exit on exception
set -e

# configure hyperspace (previously downloaded with scripts/base.sh)
cd /srv/hyperspace/hyperspace
sudo -u hyperspace sed -i "s|localhost|hyperspace-be|" etc/nginx.conf
sudo -u hyperspace sed -i '3d' etc/nginx.conf
sudo -u hyperspace sed -i '28,33d' etc/nginx.conf

# install nginx
sudo apt-get install -y nginx
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /srv/hyperspace/hyperspace/etc/nginx.conf /etc/nginx/sites-enabled/default
sudo systemctl enable nginx.service
sudo systemctl start nginx.service
