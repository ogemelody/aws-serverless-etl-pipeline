terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_kinesis_stream" "device_stream" {
  name             = "device-stream"
  shard_count      = 1
  retention_period = 24
}
