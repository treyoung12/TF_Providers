terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.45.0"
    }
  }
}

provider "google" {
  project     = "terraform-tester-370820"
  region      = "us-central1"
  credentials = "terraform-tester-370820-08b6e004f111.json"
  zone = "us-central1-c"
  }

  resource "google_compute_instance" "vm-instance" {
  name         = "terraform-instance"
  machine_type = "e2-micro"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = "default"
    access_config { }
  }


}
