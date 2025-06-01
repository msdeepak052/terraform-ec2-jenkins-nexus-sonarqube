variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "jenkins_sg_name" {
  description = "Name for Jenkins security group"
  type        = string
}

variable "nexus_sg_name" {
  description = "Name for Nexus security group"
  type        = string
}

variable "sonarqube_sg_name" {
  description = "Name for SonarQube security group"
  type        = string
}

variable "ingress_cidr_blocks" {
  description = "List of CIDR blocks to allow access to instances"
  type        = list(string)
}

variable "jenkins_ports" {
  description = "Map of ports to open for Jenkins"
  type        = map(string)
}

variable "nexus_ports" {
  description = "Map of ports to open for Nexus"
  type        = map(string)
}

variable "sonarqube_ports" {
  description = "Map of ports to open for SonarQube"
  type        = map(string)
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
}