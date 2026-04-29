terraform {
  cloud {
    organization = "TeckSolucoes"

    workspaces {
      name = "xray-template-infra"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "xray-template-infra"
      ManagedBy   = "terraform"
      Environment = "shared"
    }
  }
}
