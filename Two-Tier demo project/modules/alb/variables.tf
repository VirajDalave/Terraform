variable "vpc_id" {
  type = string
}

variable "alb_subnets" {
  type = list(string)
}

variable "security_group_name" {
  type = string
  default = "alb-sg"
}

variable "lb_name" {
  type = string
  default = "example-lb"
}

variable "application_port" {
  type = number
  default = 80
}