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

resource "aws_s3_bucket" "device_events" {
  bucket = "device-events-serveless-project"
}

resource "aws_cloudwatch_event_rule" "device_rule" {
  name        = "device-event-rule"
  description = "Rule to trigger Lambda from S3 events"
  event_pattern = <<PATTERN
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"]
}
PATTERN
}