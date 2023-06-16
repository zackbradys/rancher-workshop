resource "aws_route53_record" "aws_route53_record_studenta" {
  zone_id = "Z083283729UYESHSBXVW6"
  name    = "student${count.index + 1}a.${var.domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.aws_ec2_instance_studenta[count.index].public_ip]
  count   = var.number_of_instances
}

resource "aws_route53_record" "aws_route53_record_studentb" {
  zone_id = "Z083283729UYESHSBXVW6"
  name    = "student${count.index + 1}b.${var.domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.aws_ec2_instance_studentb[count.index].public_ip]
  count   = var.number_of_instances
}

resource "aws_route53_record" "aws_route53_record_studentc" {
  zone_id = "Z083283729UYESHSBXVW6"
  name    = "student${count.index + 1}c.${var.domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.aws_ec2_instance_studentc[count.index].public_ip]
  count   = var.number_of_instances
}

resource "aws_route53_record" "aws_route53_record_ingress" {
  zone_id = "Z083283729UYESHSBXVW6"
  name    = "*.${count.index + 1}.${var.domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.aws_ec2_instance_studenta[count.index].public_ip]
  count   = var.number_of_instances
}