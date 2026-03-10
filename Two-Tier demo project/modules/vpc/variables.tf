variable "cidr_block" {
    description = "VPC CIDR block range"
    type = string
}

variable "cidr_blocks_pub_sub" {
  type = list(string)
}

variable "cidr_blocks_priv_sub" {
  type = list(string)
}
