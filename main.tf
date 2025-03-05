#bucket s3 public to provide static landing page

# defined bucket name from variable
resource "aws_s3_bucket" "lneutfbkt" {
 
    bucket = var.bucketname  
 
    tags = { 
        Name        =  "Bucket for test"
        Environment = "dev"
    }
}

resource "aws_s3_bucket_ownership_controls" "ownerctrl" {
  bucket = aws_s3_bucket.lneutfbkt.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "bkcablock" {
  bucket = aws_s3_bucket.lneutfbkt.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_acl" "bckacl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownerctrl,
    aws_s3_bucket_public_access_block.bkcablock,
  ]

  bucket = aws_s3_bucket.lneutfbkt.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
depends_on = [
    aws_s3_bucket_ownership_controls.ownerctrl,
    aws_s3_bucket_public_access_block.bkcablock,
  ]
    bucket = aws_s3_bucket.lneutfbkt.id 
    key             = "index.html"
    source          = "index.html"
    acl             = "public-read"
    content_type    = "text/html"
}

resource "aws_s3_object" "error" {
 depends_on = [
    aws_s3_bucket_ownership_controls.ownerctrl,
    aws_s3_bucket_public_access_block.bkcablock,
  ]
    bucket = aws_s3_bucket.lneutfbkt.id 
    key             = "error.html"
    source          = "error.html"
    acl             = "public-read"
    content_type    = "text/html"
}

resource "aws_s3_bucket_website_configuration" "website" {

  depends_on = [ 
        aws_s3_bucket_acl.bckacl 
  ]

  bucket = aws_s3_bucket.lneutfbkt.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

#route53 hosted zone

resource "aws_route53_zone" "fneuzone" {
  name = var.dnsname
}
resource "aws_route53_record" "fneurec" {
  allow_overwrite = true
  name            = var.dnsname
  ttl             = 172800
  type            = "NS"
  zone_id         = aws_route53_zone.fneuzone.zone_id
  records = [
    "ns-143.awsdns-17.com",
    "ns-1824.awsdns-36.co.uk",
    "ns-797.awsdns-35.net",
    "ns-1437.awsdns-51.org",
  ]
}

resource "aws_route53_record" "s3site" {
  zone_id = aws_route53_zone.fneuzone.zone_id
  name = var.dnsname
  type = "A"
  
  alias {
    name    = aws_s3_bucket_website_configuration.website.website_domain
    zone_id = aws_s3_bucket.lneutfbkt.hosted_zone_id
    evaluate_target_health = true
  }
}