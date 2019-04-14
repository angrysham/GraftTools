/* Security group for the cryptonode */
resource "aws_security_group" "cryptonode_server_sg" {
  name        = "${var.environment}-cryptonode-server-sg"
  description = "Security group for cryptonode that allows traffic from internet"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-cryptonode-server-sg"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "cryptonode_inbound_sg" {
  name        = "${var.environment}-cryptonode-inbound-sg"
  description = "Allow HTTP from Anywhere"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.environment}-cryptonode-inbound-sg"
  }
}

/* Worker servers */
resource "aws_instance" "cryptonode" {
  count             = "${var.cryptonode_instance_count}"
  ami               = "${lookup(var.amis, var.region)}"
  instance_type     = "${var.instance_type}"
  subnet_id         = "${var.private_subnet_id}"
  vpc_security_group_ids = [
    "${aws_security_group.cryptonode_server_sg.id}"
  ]
  key_name          = "${var.key_name}"
  user_data         = "${file("${path.module}/files/user_data.sh")}"
  tags = {
    Name        = "${var.environment}-cryptonode-${count.index+1}"
    Environment = "${var.environment}"
    Role = "cryptonode"
  }
}
