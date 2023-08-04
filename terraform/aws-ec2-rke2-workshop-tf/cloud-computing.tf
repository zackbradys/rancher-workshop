resource "aws_instance" "aws_ec2_instance_studenta" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count         = var.number_of_students

  vpc_security_group_ids      = [aws_security_group.aws_rke2_sg.id]
  subnet_id                   = aws_subnet.aws_rke2_subnet.id
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = aws_iam_instance_profile.aws_iam_profile_rke2.name
  key_name                    = var.key_pair_name

  user_data = templatefile("${var.user_data_studenta}", {
    DOMAIN   = "${var.domain}"
    NUM      = "${count.index + 1}"
    HOSTNAME = "student${count.index + 1}a.${var.domain}"
  })

  tags = {
    Name = "student${count.index + 1}a"
  }

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    encrypted             = var.encrypted
    delete_on_termination = var.delete_on_termination

    tags = {
      Name = "student-volume${count.index + 1}a"
    }
  }
}

resource "aws_instance" "aws_ec2_instance_studentb" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count         = var.number_of_students

  vpc_security_group_ids      = [aws_security_group.aws_rke2_sg.id]
  subnet_id                   = aws_subnet.aws_rke2_subnet.id
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = aws_iam_instance_profile.aws_iam_profile_rke2.name
  key_name                    = var.key_pair_name

  user_data = templatefile("${var.user_data_studentb}", {
    DOMAIN   = "${var.domain}"
    NUM      = "${count.index + 1}"
    HOSTNAME = "student${count.index + 1}b.${var.domain}"
  })

  tags = {
    Name = "student${count.index + 1}b"
  }

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    encrypted             = var.encrypted
    delete_on_termination = var.delete_on_termination

    tags = {
      Name = "student-volume${count.index + 1}b"
    }
  }
}

resource "aws_instance" "aws_ec2_instance_studentc" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count         = var.number_of_students

  vpc_security_group_ids      = [aws_security_group.aws_rke2_sg.id]
  subnet_id                   = aws_subnet.aws_rke2_subnet.id
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = aws_iam_instance_profile.aws_iam_profile_rke2.name
  key_name                    = var.key_pair_name

  user_data = templatefile("${var.user_data_studentc}", {
    DOMAIN   = "${var.domain}"
    NUM      = "${count.index + 1}"
    HOSTNAME = "student${count.index + 1}c.${var.domain}"
  })

  tags = {
    Name = "student${count.index + 1}c"
  }

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    encrypted             = var.encrypted
    delete_on_termination = var.delete_on_termination

    tags = {
      Name = "student-volume${count.index + 1}c"
    }
  }
}