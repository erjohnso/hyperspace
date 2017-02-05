# Copyright 2015 Google Inc. All Rights Reserved.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Create the hyperspace user
sudo adduser --system --home /srv/hyperspace hyperspace

# Download hyperspace
cd /srv/hyperspace
sudo -u hyperspace git clone https://github.com/erjohnso/hyperspace.git
