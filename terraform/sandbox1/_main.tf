provider "aws" {
  region = "${var.region}"
  access_key = ${AWS_ACCESS_KEY_ID}
  secret_key = ${AWS_SECRET_ACCESS_KEY}
}

resource "aws_key_pair" "key" {
  key_name   = "${var.key_name}"
  public_key = "${file("staging_key.pub")}"
}
