terraform {
  required_providers {
    twc = {
      source = "tf.timeweb.cloud/timeweb-cloud/timeweb-cloud"
    }
  }
  required_version = ">= 1.3.0"
}

provider "twc" {
  token = var.TWC_TOKEN
}