provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "DBServer" {
  ami           = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  
  tags = {
    Name = "DBServer"
  }

}

output "pip" {
    value = aws_instance.DBServer.private_ip
  
}