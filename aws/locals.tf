locals {
  region  = "ap-southeast-2"
  profile = "default"
  user    = "sat0ken"
  tags = {
    user = local.user
    env  = "terraform-study"
  }
  domain_name = "test-terraform.com"

  zones  = slice(data.aws_availability_zones.available.names, 0, 2)
  cidr   = "10.0.0.0/16"
  subnet = cidrsubnets("10.0.0.0/16", 8, 8, 8, 8)

  public_subnet = zipmap(
    local.zones,
    slice(local.subnet, 0, 2)
  )
  private_subnet = zipmap(
    local.zones,
    slice(local.subnet, 2, 4)
  )
}
