# resource "aws_elb" "main_elb" {
#   name               = "main-elb"
#   subnets = [aws_subnet.public_subnet_1.id,aws_subnet.public_subnet_2.id]

#   listener {
#     instance_port     = 8000
#     instance_protocol = "http"
#     lb_port           = 80
#     lb_protocol       = "http"
#   }

#   listener {
#     instance_port      = 8000
#     instance_protocol  = "http"
#     lb_port            = 443
#     lb_protocol        = "https"
#     ssl_certificate_id = aws_iam_server_certificate.certificate.arn
#   }

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTP:8000/"
#     interval            = 30
#   }

#   cross_zone_load_balancing   = true
#   idle_timeout                = 400
#   connection_draining         = true
#   connection_draining_timeout = 400

#   tags = {
#     Name = "my-elb"
#   }
# }

# resource "aws_iam_server_certificate" "certificate" {
#   name_prefix      = "certificate"
#   certificate_body = file("cert.pem")
#   private_key      = file("key.pem")

#   lifecycle {
#     create_before_destroy = true
#   }
# }