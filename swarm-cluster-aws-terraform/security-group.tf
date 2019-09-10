data "external" "my-ip" {
 program = ["bash", "whatismyip.sh"]
}

resource "aws_security_group" "swarm-cluster" {
  name = "swarm-cluster-sg"
  description = "Security group that allows inbound and outbound traffic from all instances in the VPC"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#  ingress {
#    from_port = 22
#    to_port   = 22
#    protocol  = "tcp"
#    cidr_blocks = ["${data.external.my-ip.result["internet_ip"]}/32"]
#  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  egress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = { 
    Name = "swarm-cluster" 
  }
}