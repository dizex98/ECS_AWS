variable "region" {
  default     = "eu-north-1"
  description = "AWS region"
}

variable "az1" {
  type = string
  default = "eu-north-1a"
}

variable "az2" {
  type = string
  default = "eu-north-1b"
}

variable "ami" {
  type = string
  default = "ami-02cf11196cf0818e8"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "fargate_cpu" {
  default = "1024"
}

variable "fargate_memory" {
  default = "2048"
}

variable "app_port" {
  default = "80"
}

variable "app_count" {
  default = "2"
}

variable "app_image" {
  default     = "public.ecr.aws/c7l4l0y6/itay-hello-world:latest"
  description = "docker image to run in this ECS cluster"
}