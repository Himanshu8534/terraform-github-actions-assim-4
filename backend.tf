terraform {
  backend "s3" {
    bucket = "himanshu-terraform-123"
    key    = "ec2-project/terraform.tfstate"
    region = "ap-south-1"
  }
}
