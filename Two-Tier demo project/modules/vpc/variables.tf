variable "cidr_block" {
    description = "VPC CIDR block range"
    type = string
    default = "10.0.0.0/16"
}

variable "cidr_blocks_pub_sub" {
  type = list(string)
  default = [ "10.0.1.0/24" ]
}

variable "cidr_blocks_priv_sub" {
  type = list(string)
  default = [ "10.0.2.0/24" ]
}

variable "availability_zones" {
  type = list(string)
  default = ["ap-south-1a"]
}