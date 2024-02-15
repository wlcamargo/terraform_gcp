terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("key_gcp.json")
  project    = "sonic-airfoil-411711"
  region     = "us-central1"
}

resource "google_compute_address" "static" {
  name = "my-static-ip"
}

resource "google_compute_instance" "vm-terraform" {
  name         = "vm-terraform"
  machine_type = "e2-standard-4"
  zone         = "us-central1-a" 

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20240112"
      size = 40
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  metadata_startup_script = "echo hi terraform! > /test.txt"
}
