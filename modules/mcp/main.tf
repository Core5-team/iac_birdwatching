terraform {
  backend "s3" {}
}
resource "aws_subnet" "mcp_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.mcp_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(
    var.common_tags,
    { Name = "private_${var.availability_zone}_mcp_${var.env}" }
  )
}
resource "aws_route_table" "mcp_private_rt" {
  vpc_id = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "mcp_private_rt_${var.env}"
  })
}

resource "aws_route" "mcp_nat_route" {
  route_table_id         = aws_route_table.mcp_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
}

resource "aws_route_table_association" "mcp_private_assoc" {
  subnet_id      = aws_subnet.mcp_subnet.id
  route_table_id = aws_route_table.mcp_private_rt.id
}

resource "aws_ebs_volume" "mcp_volume" {
  availability_zone = var.availability_zone
  size              = 1
  type              = "gp3"

  tags = merge(
    var.common_tags,
    { Name = "mcp_volume_${var.env}" }
  )
}

resource "aws_security_group" "mcp_sg" {
  vpc_id = var.vpc_id
  name   = "mcp_sg_${var.env}"

  ingress {
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 8300
    to_port         = 8302
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 8301
    to_port         = 8302
    protocol        = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    { Name = "mcp_sg_${var.env}" }
  )
}
resource "aws_iam_role" "ssm_role" {
  name = "EC2-SSM-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "EC2-SSM-Instance-Profile"
  role = aws_iam_role.ssm_role.name
}


resource "aws_instance" "mcp" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.mcp_subnet.id
  vpc_security_group_ids      = [aws_security_group.mcp_sg.id]
  key_name                    = null
  iam_instance_profile        = aws_iam_instance_profile.ssm_instance_profile.name
  user_data_replace_on_change = true

  tags = merge(
    var.common_tags,
    { Name = "mcp_instance_${var.env}" }
  )
}

resource "aws_volume_attachment" "mcp_volume_attachment" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.mcp_volume.id
  instance_id = aws_instance.mcp.id
}

