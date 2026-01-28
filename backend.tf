terraform {
  backend "s3" {
    bucket = "terraedge-tf-state-buket"
    key    = "terraedge/terraform.tfstate"
    region = "us-east-1"
    # encrypt        = true
  }
}
