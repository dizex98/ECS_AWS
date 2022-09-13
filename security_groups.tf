resource "aws_security_group" "main" {
    name        = "main"
    vpc_id      = aws_vpc.main.id 
    description = "Allow HTTP and HTTPS inbound traffic"

    ingress {
        from_port        = 80
        to_port          = 80
        protocol         = "TCP"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        from_port        = 443
        to_port          = 443
        protocol         = "TCP"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = -1
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]    
    }

    tags = {
        Name = "Main Security Group"
    }
}

