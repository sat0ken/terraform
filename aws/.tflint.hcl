plugin "aws" {
  enabled    = true
  module     = true
  deep_check = true
  region     = "ap-southeast-2"
  profile    = "default"
  shared_credentials_file = "~/.aws/credentials"
}
