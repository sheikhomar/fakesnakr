# Prediction Backend

## Getting Started

[Test the Lambda function locally](https://docs.aws.amazon.com/lambda/latest/dg/images-test.html):

```bash
# Ensure we can download from ghcr.io
docker login ghcr.io

IMAGE_NAME=ghcr.io/sheikhomar/fakesnakr/prediction-backend:v0.1.0

# Build Docker image
docker build -f Dockerfile -t $IMAGE_NAME .

# Run Docker container
docker run -it --rm -p 9000:8080 $IMAGE_NAME

# Test the local endpoint
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
```

Deploying via Terraform:

```bash
# Define AWS region and creditials
export AWS_REGION=eu-west-2
export AWS_FAKESNAKR_KEY=<AWS_ACCESS_KEY_ID>
export AWS_FAKESNAKR_SECRET=<AWS_SECRET_ACCESS_KEY>
terraform init
# terraform plan
terraform apply -auto-approve
# terraform destroy
```
