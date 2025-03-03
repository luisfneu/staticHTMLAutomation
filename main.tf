#bucket s3 public to provide static landing page

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
    bucket = aws_s3_bucket.lneutfbkt.id 
    key             = "index.html"
    source          = "index.html"
    acl             = "public-read"
    content_type    = "text/html"
}

resource "aws_s3_object" "style" {
    bucket = aws_s3_bucket.lneutfbkt.id 
    key             = "styles.css"
    source          = "styles.css"
    acl             = "public-read"
    content_type    = "text/html"
}

resource "aws_s3_object" "error" {
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