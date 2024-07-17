provider "google" {
  credentials = file("account.json")
  project     = "my-webserver"
  region      = "us-central1"
}

resource "google_compute_instance" "webserver" {
  name         = "webserver"
  machine_type = "f1-micro"
  zone         = "us-central1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // This will create an external IP address
    }
  }

  metadata = {
    ssh-keys = "user:ssh-rsa ... "
  }
}

resource "google_compute_firewall" "webserver" {
  name    = "webserver"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["webserver"]
}
