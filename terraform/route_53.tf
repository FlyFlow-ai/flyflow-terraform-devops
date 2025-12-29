resource "aws_route53_zone" "my_domain" {
  name = "flyflow.io"
}

# 2️⃣ Store the Nameservers in AWS SSM Parameter Store
resource "aws_ssm_parameter" "route53_nameservers" {
  name  = "/route53/nameservers"
  type  = "SecureString"  # Keep it secure
  value = join(",", aws_route53_zone.my_domain.name_servers)
}
# 3️⃣ Create a CNAME Record (For www → root domain)
resource "aws_route53_record" "cname_record" {
  zone_id = aws_route53_zone.my_domain.zone_id
  name    = "www.flyflow.io"
  type    = "CNAME"
  ttl     = 300
  records = ["flyflow.io"]
}
resource "aws_route53_record" "jenkins_subdomain" {
  zone_id = aws_route53_zone.my_domain.zone_id
  name    = "jenkins.flyflow.io"
  type    = "A"
  ttl     = 300
  records = ["34.236.149.167"]  # Replace with your EC2 instance public IP
}
# 3️⃣ Output the SSM Parameter Name (for easy retrieval)
output "ssm_parameter_name" {
  value = aws_ssm_parameter.route53_nameservers.name
}