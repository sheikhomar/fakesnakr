# Adapted from: https://hands-on.cloud/terraform-deploy-python-lambda-container-image/

data external env {
  program = ["${path.module}/prepare-terraform.sh"]
}

locals {
  prefix = "fakesnakr-prediction-backend"
  aws_region = data.external.env.result["aws_region"]
  aws_access_key = data.external.env.result["aws_access_key"]
  aws_secret_key = data.external.env.result["aws_secret_key"]
  lambda_payload = data.external.env.result["lambda_payload"]
  lambda_runtime = data.external.env.result["lambda_runtime"]
  container_repo_name = "ghcr.io/sheikhomar/fakesnakr/prediction-backend"
  container_repo_tag = "v0.1.0"
}

provider aws {
  region = local.aws_region
  access_key = local.aws_access_key
  secret_key = local.aws_secret_key
}

# Declare a role for the Lambda function
resource aws_iam_role lambda {
 name = "${local.prefix}-lambda-role"
 assume_role_policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Action": "sts:AssumeRole",
           "Principal": {
               "Service": "lambda.amazonaws.com"
           },
           "Effect": "Allow"
       }
   ]
}
 EOF
}

# Define a policy document which grants the Lambda function
# permission to access CloudWatch.
data aws_iam_policy_document lambda {
   statement {
     actions = [
         "logs:CreateLogGroup",
         "logs:CreateLogStream",
         "logs:PutLogEvents"
     ]
     effect = "Allow"
     resources = [ "*" ]
     sid = "CreateCloudWatchLogs"
   }
}

# Attach the policy document to the role.
resource aws_iam_policy lambda {
   name = "${local.prefix}-lambda-policy"
   path = "/"
   policy = data.aws_iam_policy_document.lambda.json
}

resource aws_lambda_function lambda {
  function_name = "${local.prefix}-lambda"
  package_type = "Zip"
  filename = local.lambda_payload
  source_code_hash = filebase64sha256(local.lambda_payload)
  handler = "app.handler"
  runtime = local.lambda_runtime
  role = aws_iam_role.lambda.arn
  timeout = 300
}

output "lambda_name" {
 value = aws_lambda_function.lambda.id
}
