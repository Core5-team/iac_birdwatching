resource "aws_subnet" "db_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.db_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(
    var.common_tags,
    { Name = "private_${var.availability_zone}_db_${var.env}" }
  )
}
resource "aws_route_table" "db_private_rt" {
  vpc_id = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "db_private_rt_${var.env}"
  })
}

resource "aws_route" "db_nat_route" {
  route_table_id         = aws_route_table.db_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
}

resource "aws_route_table_association" "db_private_assoc" {
  subnet_id      = aws_subnet.db_subnet.id
  route_table_id = aws_route_table.db_private_rt.id
}

resource "aws_ebs_volume" "db_volume" {
  availability_zone = var.availability_zone
  size              = 1
  type              = "gp3"

  tags = merge(
    var.common_tags,
    { Name = "db_volume_${var.env}" }
  )
}

resource "aws_security_group" "db_sg" {
  vpc_id = var.vpc_id
  name   = "db_sg_${var.env}"

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

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    { Name = "db_sg_${var.env}" }
  )
}

resource "aws_instance" "db" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.db_subnet.id
  vpc_security_group_ids      = [aws_security_group.db_sg.id]
  key_name                    = var.key_pair
  iam_instance_profile        = var.iam_instance_profile
  user_data_replace_on_change = true

  tags = merge(
    var.common_tags,
    { Name = "db_instance_${var.env}" }
  )
}

resource "aws_volume_attachment" "db_volume_attachment" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.db_volume.id
  instance_id = aws_instance.db.id
}

