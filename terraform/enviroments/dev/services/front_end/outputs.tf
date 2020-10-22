output "s3_blob_url" {
  value = aws_s3_bucket.blob.bucket_regional_domain_name
}

output "cf_domain" {
  value = module.cf.cloudfront_distribution_domain_name
}