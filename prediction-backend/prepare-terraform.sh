#!/bin/sh

# Exit if any of the intermediate steps fail
set -e

if [ -z "$AWS_REGION" ]; then
  echo "Environment variable AWS_REGION is empty."
  echo "You can set by running the Bash command: export AWS_REGION=eu-west-2"
  exit 1
fi

if [ -z "$AWS_FAKESNAKR_KEY" ]; then
  echo "Environment variable AWS_FAKESNAKR_KEY is empty."
  echo "You can set by running the Bash command: export AWS_FAKESNAKR_KEY=<YOUR_AWS_ACCESS_KEY_ID>"
  exit 1
fi

if [ -z "$AWS_FAKESNAKR_SECRET" ]; then
  echo "Environment variable AWS_FAKESNAKR_SECRET is empty."
  echo "You can set by running the Bash command: export AWS_FAKESNAKR_SECRET=<YOUR_AWS_SECRET_ACCESS_KEY>"
  exit 1
fi


PAYLOAD_FILE="dist/lambda-payload.zip"
LAMBDA_RUNTIME="python3.8"

mkdir -p dist
zip $PAYLOAD_FILE app.py requirements.txt > /dev/null 2>&1

cat <<EOF
{
  "lambda_payload": "$PAYLOAD_FILE",
  "lambda_runtime": "$LAMBDA_RUNTIME",
  "aws_region": "$AWS_REGION",
  "aws_access_key": "$AWS_FAKESNAKR_KEY",
  "aws_secret_key": "$AWS_FAKESNAKR_SECRET"
}
EOF
