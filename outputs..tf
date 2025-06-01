output "jenkins_instance_ip" {
  description = "Public IP of Jenkins instance"
  value       = aws_eip.jenkins.public_ip
}

output "nexus_instance_ip" {
  description = "Public IP of Nexus instance"
  value       = aws_eip.nexus.public_ip
}

output "sonarqube_instance_ip" {
  description = "Public IP of SonarQube instance"
  value       = aws_eip.sonarqube.public_ip
}