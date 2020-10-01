provider vra {
  url           = var.vra_url
  refresh_token = var.vra_refresh_token
}

# Set up the Cloud Account
resource "vra_cloud_account_aws" "this" {
  name        = "AWS Cloud Account"
  description = "AWS Cloud Account configured by Terraform"
  access_key  = var.aws_access_key
  secret_key  = var.aws_secret_key
  regions     = ["us-east-1", "us-west-1"]

  tags {
    key   = "cloud"
    value = "aws"
  }
}

data "vra_region" "this" {
  cloud_account_id = vra_cloud_account_aws.this.id
  region           = "us-west-1"
}

# Configure a new Cloud Zone
resource "vra_zone" "this" {
  name        = "AWS US West Zone"
  description = "Cloud Zone configured by Terraform"
  region_id   = data.vra_region.this.id

  tags {
    key   = "cloud"
    value = "aws"
  }
}

# Create an flavor profile
resource "vra_flavor_profile" "this" {
  name        = "terraform-flavour-profile"
  description = "Flavour profile created by Terraform"
  region_id   = data.vra_region.this.id

  flavor_mapping {
    name          = "x-small"
    instance_type = "t2.micro"
  }

  flavor_mapping {
    name          = "small"
    instance_type = "t2.small"
  }

  flavor_mapping {
    name          = "medium"
    instance_type = "t2.medium"
  }
  
  flavor_mapping {
    name          = "large"
    instance_type = "t2.large"
  }
}

# Create a new image profile
resource "vra_image_profile" "this" {
  name        = "terraform-aws-image-profile"
  description = "AWS image profile created by Terraform"
  region_id   = data.vra_region.this.id

  image_mapping {
    name       = "ubuntu-bionic"
    image_name = "ami-0dd655843c87b6930"
  }
}

# Create a new Project
resource "vra_project" "this" {
  name        = "Terraform Project"
  description = "Project configured by Terraform"

  administrators = ["smcgeown@vmware.com"]
  members           = ["cas-user1@definit.co.uk"]

  zone_assignments {
    zone_id       = vra_zone.this.id
    priority      = 1
    max_instances = 0
  }
}