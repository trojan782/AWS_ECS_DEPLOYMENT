terraform {
  backend "s3" {
    bucket         = "your_bucket_name"
    key            = "wp_ecs/vpc/terraform.tfstate"  # Different for each environment
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}