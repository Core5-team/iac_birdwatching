data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda_execution_role_${var.env}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "bird_job" {
  function_name = "bird_daily_job_${var.env}"
  s3_bucket     = var.zip_bucket_name
  s3_key        = var.zip_object_key
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 100
  memory_size   = 256
  role          = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      UNSPLASH_KEY           = var.unsplash_key
      BIRDWATCHING_URL       = var.birdwatch_url
      MAIL_SERVICE           = var.mail_service
      ILLUMINATI_BACKEND_URL = var.illuminati_backend
      UNSPLASH_URL           = var.unsplash_url
      EBIRD_API_KEY          = var.ebird_api_key
      EBIRD_URL              = var.ebird_url
    }
  }
}

resource "aws_cloudwatch_event_rule" "daily_schedule" {
  name                = "bird_lambda_daily_${var.env}"
  schedule_expression = "cron(0 0 * * ? *)"

}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_schedule.name
  target_id = "bird_job_${var.env}"
  arn       = aws_lambda_function.bird_job.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.bird_job.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_schedule.arn
}
