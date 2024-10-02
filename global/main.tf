terraform {
  backend "s3" {
    bucket         = "your_bucket_name"
    key            = "global/s3/terraform.tfstate"  # Different for each environment
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}