####################
# Security Group
####################
resource "aws_security_group" "allow_tls" {
  name        = "allowTLS"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allowTLS"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.main.cidr_block

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_trafic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"

  ip_protocol = "-1"
}

####################
# Application Load Balancer
####################
resource "aws_lb" "primary" {
  load_balancer_type = "application"

  name            = "primary"
  internal        = false
  ip_address_type = "ipv4"

  subnets = [
    aws_subnet.public_alb_primary.id,
    aws_subnet.public_alb_secondary.id
  ]

  security_groups = [aws_security_group.allow_tls.id]
}

####################
# Listener
####################
resource "aws_lb_listener" "allow_tls" {
  load_balancer_arn = aws_lb.primary.arn

  protocol = "HTTPS"
  port     = 443

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.send_to_fargate.arn
  }

  tags = {
    Name = "allowTLS"
  }
}

####################
# Target Group
####################
resource "aws_alb_target_group" "send_to_fargate" {
  target_type      = "ip"
  name             = "sendToFargate"
  protocol         = "HTTP"
  port             = 80
  vpc_id           = aws_vpc.main.id
  protocol_version = "HTTP1"

  load_balancing_algorithm_type = "round_robin"
}
