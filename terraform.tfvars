# Common Variables
ami_id        = "ami-0e35ddab05955cf57"  # Amazon Linux 2 AMI (replace with your preferred AMI)
instance_type = "t2.medium"               # Default instance type (overridden for Nexus/SonarQube)
key_name      = "newawss"     # Your existing EC2 key pair name
vpc_id        = "vpc-0b4d8673f9549d276"           # Your VPC ID
subnet_ids    = ["subnet-07d0f65b80ead8bb3"]      # List of subnet IDs (using first one)

# Security Group Variables (add these to your variables.tf if not already present)
jenkins_sg_name    = "jenkins-security-group"
nexus_sg_name      = "nexus-security-group"
sonarqube_sg_name  = "sonarqube-security-group"

# Security Group Rules
ingress_cidr_blocks = ["0.0.0.0/0"]  # WARNING: Open to public for demo purposes
                                      # Restrict to your IP in production

# Ports to open for each service
jenkins_ports = {
  "8080" = "HTTP"
  "50000" = "JNLP"
  "22" = "SSH"
}

nexus_ports = {
  "8081" = "HTTP"
  "22" = "SSH"
}

sonarqube_ports = {
  "9000" = "HTTP"
  "22" = "SSH"
}

# Instance-specific tags
tags = {
  Environment = "dev"
  Project     = "ci-cd"
  Terraform   = "true"
}