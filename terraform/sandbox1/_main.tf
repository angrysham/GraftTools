provider "aws" {
  region = "${var.region}"
  access_key = "AKIAJCYUMJKWV5UNNFBQ"
  secret_key = "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"
}

resource "aws_key_pair" "key" {
  key_name   = "${var.key_name}"
  public_key = "${file("staging_key.pub")}"
}
