resource "aws_route53_zone" "main" {
  name = var.dns_name
  tags = var.common_tags
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = "public_lb_subnet_${var.availability_zone}_${var.env}"
  })
}

resource "aws_eip" "lb_eip" {
  tags = merge(var.common_tags, {
    Name = "lb_eip_${var.env}"
  })
}

resource "aws_eip" "nat_eip" {
  tags = merge(var.common_tags, {
    Name = "nat_eip_${var.env}"
  })
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id
}

resource "aws_route" "public_inet_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "lb_sg" {
  vpc_id = var.vpc_id
  name   = "basic-security-group-${var.env}"

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    from_port   = 8300
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    from_port   = 8301
    to_port     = 8302
    protocol    = "udp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "lb_sg_${var.env}"
  })
}

resource "aws_instance" "lb" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.lb_sg.id]
  key_name                    = var.key_name
  iam_instance_profile        = var.iam_instance_profile
  user_data_replace_on_change = true

  tags = merge(var.common_tags, {
    Name = "lb_instance_${var.env}"
  })
}

resource "aws_eip_association" "lb_assoc" {
  instance_id   = aws_instance.lb.id
  allocation_id = aws_eip.lb_eip.id
}

resource "aws_route53_record" "dns_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.dns_name
  type    = "A"
  ttl     = 300
  records = [aws_eip.lb_eip.public_ip]
}

