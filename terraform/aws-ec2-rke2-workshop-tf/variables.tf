variable "region" {
  default     = "us-east-1"
  description = "(Required) The AWS Region to use for the instance(s)."
}

variable "access_key" {
  default = ""
  description = "(Required) The AWS Access Key to use for the instance(s)."
}

variable "secret_key" {
  default = ""
  description = "(Required) The AWS Secret Key to use for the instance(s)."
}

variable "key_pair_name" {
  default     = "aws-zackbradys-work"
  description = "(Required) The AWS Key Pair name to use for the instance(s)."
}

variable "domain" {
  default     = "rancherfederal.training"
  description = "(Required) The AWS Route53 Domain to use for the instance(s)."
}

variable "token" {
  default = "awsRKE2terraform"
  description = "(Required) The RKE2 Cluster Join Token to use for the cluster(s)."
}

variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  description = "(Required) The AWS VPC CIDR Block to use for the instance(s)."
}

variable "subnet_cidr_block" {
  default     = "10.0.0.0/24"
  description = "(Required) The AWS Subnet CIDR Blocks to use for the instance(s)."
}

variable "ami_id" {
  default     = "ami-0cce0fd28f5ae1c16"
  description = "(Required) The AWS AMI ID to use for the instance(s)."
}

variable "instance_type" {
  default     = "m5d.xlarge"
  description = "(Required) The AWS Instance type to use for the instance(s)."
}

variable "number_of_students" {
  default     = 1
  description = "(Required) The number of students to use for the instance(s)."
}

variable "associate_public_ip_address" {
  default     = true
  description = "(Required) Associate AWS Public IP Address for use for the instance(s)."
}

variable "user_data_studenta" {
  default     = "scripts/studenta.sh"
  description = "(Required) The AWS User Data to use for the instance(s)."
}

variable "user_data_studentb" {
  default     = "scripts/studentb.sh"
  description = "(Required) The AWS User Data to use for the instance(s)."
}

variable "user_data_studentc" {
  default     = "scripts/studentc.sh"
  description = "(Required) The AWS User Data to use for the instance(s)."
}

variable "volume_size" {
  default     = 128
  description = "(Required) The AWS Volume Size to use for the instance(s)."
}

variable "volume_type" {
  default     = "gp2"
  description = "(Required) The AWS Volume Type to use for the instance(s)."
}

variable "encrypted" {
  default     = true
  description = "(Required) Volume Encryption for use for the instance(s)."
}

variable "delete_on_termination" {
  default     = true
  description = "(Required) Delete on Termination for the instance(s)."
}