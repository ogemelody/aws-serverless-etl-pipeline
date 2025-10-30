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


#=====================================================
#  S3 BUCKET
#=====================================================
resource "aws_s3_bucket" "device_events" {
  bucket = "device-events-serveless-project"
}

#=====================================================
#   Event - bridge Rule
#=====================================================
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

#=====================================================
#  IAM role for Lambda
#=====================================================
resource "aws_iam_role" "lambda_exec" {
  name = "etl-lambda-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [{
    "Action": "sts:AssumeRole",
    "Principal": { "Service": "lambda.amazonaws.com" },
    "Effect": "Allow"
  }]
}
POLICY
}

#=====================================================
# Attach basic execution policy
#=====================================================
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#=====================================================
#  Lambda function
#=====================================================
resource "aws_lambda_function" "etl_lambda" {
  function_name = "etl_lambda"
  filename      = "../lambda/lambda_function.zip"  #  packaged code
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256("../lambda/lambda_function.zip")
}

#=====================================================
#  Connect EventBridge to Lambda
#=====================================================
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.device_rule.name
  target_id = "etlLambdaTarget"
  arn       = aws_lambda_function.etl_lambda.arn
}

#=====================================================
#  Give EventBridge permission to invoke Lambda
#=====================================================
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.etl_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.device_rule.arn
}
