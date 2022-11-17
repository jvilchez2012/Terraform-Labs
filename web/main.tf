provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "WebServer" {
  ami           = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_tls.name] 
  user_data="${file("server-script.sh")}" 
  tags = {
    Name = "WebServer"
  }

}

resource "aws_eip" "web_eip" {
  instance = aws_instance.WebServer.id
  
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"


  ingress {
    description      = "Plain from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    
   
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
   
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

output "web" {
  value = aws_eip.web_eip.public_ip

}
