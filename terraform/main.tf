// Copyright 2017 Google Inc. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

provider "google" {
  credentials = ""
  project      = "modern-girder-157718"
  region       = "us-central1"
}

//
// INSTANCES
//
resource "google_compute_instance" "hyperspace-be" {
  name         = "hyperspace-be"
  machine_type = "n1-standard-1"
  zone         = "us-central1-f"

  disk {
      image = "hyperspace-be"
  }

  network_interface {
      network = "default"
      access_config {
          // Ephemeral IP
      }
  }
  count = 1
  lifecycle = {
    create_before_destroy = true
  }
}

resource "google_compute_instance" "hyperspace-fe" {
  name         = "${format("hyperspace-fe-%d", count.index)}"
  machine_type = "n1-standard-1"
  zone         = "us-central1-f"
  tags         = ["hyperspace-fe"]

  disk {
      image = "hyperspace-fe"
  }

  network_interface {
      network = "default"
      access_config {
          // Ephemeral IP
      }
  }
  count = 3
  lifecycle = {
    create_before_destroy = true
  }
}

//
// NETWORKING
//
resource "google_compute_firewall" "fwrule" {
    name = "hyperspace-web"
    network = "default"
    allow {
        protocol = "tcp"
        ports = ["80"]
    }
    target_tags = ["hyperspace-fe"]
}

resource "google_compute_forwarding_rule" "fwd_rule" {
    name = "fwdrule"
    target = "${google_compute_target_pool.tpool.self_link}"
    port_range = "80"
}

resource "google_compute_target_pool" "tpool" {
    name = "tpool"
    instances = [
        "${google_compute_instance.hyperspace-fe.*.self_link}"
    ]
}

output "lb_ip" {
  value = "${google_compute_forwarding_rule.fwd_rule.ip_address}"
}
