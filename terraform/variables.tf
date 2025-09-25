variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  description = "ubuntu AMI FOR ap-south-1"
  default     = "ami-02d26659fd82cf299"  # Update for region
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_pair_name" {
  description = "mywebserver"
  type        = string
}

variable "vpc_id" {
  description = "vpc-057b93e3fa6e2c141"
  type        = string
}

variable "subnet_id" {
  description = "subnet-0a234787f5771af36"
  type        = string
}
