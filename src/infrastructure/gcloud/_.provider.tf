terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.39.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
