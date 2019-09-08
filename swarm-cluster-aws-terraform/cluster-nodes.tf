provider "aws" {
    region = "us-east-1"
    profile = "swarm-cluster-deployer"
}

resource "aws_instance" "swarm-manager" {
    ami = "ami-2757f631"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.swarm-cluster.name}"]
    key_name = "${aws_key_pair.deployer.key_name}"

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",
            "curl -fsSL https://get.docker.com -o get-docker.sh",
            "sh get-docker.sh",
            "sudo docker swarm init",
            "sudo docker swarm join-token --quiet worker > /home/ubuntu/token"
        ]
    }

#    provisioner "file" {
#        source = "docker-swarm-files"
#        destination = "/home/ubuntu/"
#    } 

    tags = { 
        Name = "swarm-cluster"
    }
}