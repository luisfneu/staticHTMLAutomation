output "endpoint" {
  description = "Acessar site na URL http://"
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}