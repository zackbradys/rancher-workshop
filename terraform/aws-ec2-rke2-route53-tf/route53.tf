resource "aws_route53_zone" "aws_rke2_zone" {
  name = var.domain
  force_destroy = true
  comment = "AWS RKE2 Route53 Hosted Zone"
}

### WIP WIP WIP