resource "aws_subnet" "private_web_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_web_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(var.common_tags, {
    Name = "private_web_subnet_${var.availability_zone}_${var.env}"
  })
}
resource "aws_route_table" "web_private_rt" {
  vpc_id = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "web_private_rt_${var.env}"
  })
}

resource "aws_route" "web_nat_route" {
  route_table_id         = aws_route_table.web_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
}

resource "aws_route_table_association" "web_private_assoc" {
  subnet_id      = aws_subnet.private_web_subnet.id
  route_table_id = aws_route_table.web_private_rt.id
}

resource "aws_security_group" "web_sg" {
  vpc_id = var.vpc_id
  name   = "web-security-group-${var.env}"

  ingress {
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = var.allowed_cidrs
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = var.allowed_cidrs
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = var.allowed_cidrs
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = var.allowed_cidrs
  }

  ingress {
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    security_groups = var.allowed_cidrs
  }

  ingress {
    from_port       = 8300
    to_port         = 8302
    protocol        = "tcp"
    security_groups = var.allowed_cidrs
  }

  ingress {
    from_port       = 8301
    to_port         = 8302
    protocol        = "udp"
    security_groups = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "web_sg_${var.env}"
  })
}

resource "aws_iam_role" "photosaver_role" {
  name = "photosaver_role_${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "photosaver_policy" {
  role       = aws_iam_role.photosaver_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "photosaver_profile" {
  name = "photosaver_profile_${var.env}"
  role = aws_iam_role.photosaver_role.name
}
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.photosaver_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_instance" "web" {
  ami                         = var.ami
  count                       = 2
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_web_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.photosaver_profile.name
  user_data_replace_on_change = true

  tags = merge(var.common_tags, {
    Name = "web_instance_${var.env}"
  })
}

