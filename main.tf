# Security Group for Jenkins
resource "aws_security_group" "jenkins" {
  name        = var.jenkins_sg_name
  description = "Security group for Jenkins server"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.jenkins_ports
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = var.ingress_cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = var.jenkins_sg_name
  })
}

# Security Group for Nexus
resource "aws_security_group" "nexus" {
  name        = var.nexus_sg_name
  description = "Security group for Nexus server"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.nexus_ports
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = var.ingress_cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = var.nexus_sg_name
  })
}

# Security Group for SonarQube
resource "aws_security_group" "sonarqube" {
  name        = var.sonarqube_sg_name
  description = "Security group for SonarQube server"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.sonarqube_ports
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = var.ingress_cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = var.sonarqube_sg_name
  })
}

# Jenkins EC2 Instance
resource "aws_instance" "jenkins" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  key_name               = var.key_name
  user_data              = file("${path.module}/userdata/jenkins.sh")

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = merge(var.tags, {
    Name = "jenkins-server"
  })
}

# Nexus EC2 Instance
resource "aws_instance" "nexus" {
  ami                    = var.ami_id
  instance_type          = "t2.medium" # Nexus requires more resources
  subnet_id              = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.nexus.id]
  key_name               = var.key_name
  user_data              = file("${path.module}/userdata/nexus.sh")

  root_block_device {
    volume_size = 10 # Increased from 10 to 30 for Nexus storage needs
    volume_type = "gp2"
  }

  tags = merge(var.tags, {
    Name = "nexus-server"
  })
}

# SonarQube EC2 Instance
resource "aws_instance" "sonarqube" {
  ami                    = var.ami_id
  instance_type          = "t2.medium" # SonarQube requires moderate resources
  subnet_id              = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.sonarqube.id]
  key_name               = var.key_name
  user_data              = file("${path.module}/userdata/sonarqube.sh")

  root_block_device {
    volume_size = 10 # Increased from 10 to 20 for SonarQube storage
    volume_type = "gp2"
  }

  tags = merge(var.tags, {
    Name = "sonarqube-server"
  })
}

# Elastic IP for Jenkins
resource "aws_eip" "jenkins" {
  instance = aws_instance.jenkins.id
  vpc      = true
  tags = merge(var.tags, {
    Name = "jenkins-eip"
  })
}

# Elastic IP for Nexus
resource "aws_eip" "nexus" {
  instance = aws_instance.nexus.id
  vpc      = true
  tags = merge(var.tags, {
    Name = "nexus-eip"
  })
}

# Elastic IP for SonarQube
resource "aws_eip" "sonarqube" {
  instance = aws_instance.sonarqube.id
  vpc      = true
  tags = merge(var.tags, {
    Name = "sonarqube-eip"
  })
}