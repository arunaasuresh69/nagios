terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# terraform {
#   required_providers {
    
#   }
# }

# provider "docker" {}
