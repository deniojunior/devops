provider "aws" {
    region = "us-east-1"
    profile = "swarm-cluster-deployer"
}

resource "aws_instance" "swarm-manager" {
    ami = "ami-2757f631"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.swarm-cluster.name}"]
    key_name = "${aws_key_pair.swarm-cluster-deployer.key_name}"

    connection{
        host = "${self.public_ip}"
        user = "ubuntu"
    }

    provisioner "file" {
        source = "swarm-cluster"
        destination = "/home/ubuntu/swarm-cluster"
    } 

    provisioner "remote-exec" {
        inline = [
            "bash /home/ubuntu/swarm-cluster/install_docker.sh",
            "sudo docker swarm init",
            "sudo docker swarm join-token --quiet worker > /home/ubuntu/token"
        ]
    }

    tags = {
        Name = "swarm-cluster-manager"
    }
}

resource "aws_instance" "swarm-worker" {
    count = 2
    ami = "ami-2757f631"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.swarm-cluster.name}"]
    key_name = "${aws_key_pair.swarm-cluster-deployer.key_name}"

    connection{
        host = "${self.public_ip}"
        user = "ubuntu"
    }
 
    provisioner "file" {
        source = "swarm-cluster"
        destination = "/home/ubuntu/swarm-cluster"
    }

    provisioner "file" {
        source = "~/.ssh/id_rsa"
        destination = "/home/ubuntu/.ssh/manager_key"
    }

    provisioner "remote-exec" {
        inline = [
            "bash /home/ubuntu/swarm-cluster/install_docker.sh",
            "sudo chmod 400 ~/.ssh/manager_key",
            "sudo scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -i ~/.ssh/manager_key ubuntu@${aws_instance.swarm-manager.private_ip}:/home/ubuntu/token .",
            "sudo docker swarm join --token $(cat /home/ubuntu/token) ${aws_instance.swarm-manager.private_ip}:2377"
        ]
    }

    tags = {
        Name = "swarm-cluster-worker-${count.index}"
    }
}