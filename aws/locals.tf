locals {
  region  = "ap-southeast-2"
  profile = "default"
  user = "sat0ken"
  tags = {
    user = local.user
    env  = "terraform-study"
  }
}
