variable "vpc_id" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "security_group_name" {
  type = string
  default = "two-tier-lb"
}

variable "application_port" {
  type = number
  default = 80
}

variable "launch_template_name" {
  type = string
  default = "example-lt"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "asg_name" {
  type = string
  default = "example-asg"
}

variable "desired_capacity" {
  type = number
}

variable "max_size" {
  default = 4
}

variable "min_size" {
  default = 1
}