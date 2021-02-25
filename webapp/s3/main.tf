resource "aws_s3_bucket" "kundu-pastbook" {
  bucket = "kundu-pastbook"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
   versioning {
    enabled = false
  }
}
