provider "aws" {
    region  = "${var.region}"
    profile = "${var.profile}"
}

resource "aws_instance" "swarm-manager" {
    ami             = "${var.ami}"
    instance_type   = "${var.instance_type}"
    security_groups = ["${aws_security_group.swarm-cluster.name}"]
    key_name        = "${aws_key_pair.swarm-cluster-deployer.key_name}"

    connection{
        host = "${self.public_ip}"
        user = "${var.ec2-user}"
    }

    provisioner "file" {
        source      = "${var.application_path}"
        destination = "/home/${var.ec2-user}/"
    } 

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",
            "curl -fsSL https://get.docker.com -o get-docker.sh",
            "sh get-docker.sh",
            "sudo docker swarm init",
            "sudo docker swarm join-token --quiet worker > /home/${var.ec2-user}/token",
            "sudo docker stack deploy -c ${var.application_path}/docker-compose.yaml ${var.application_name}"
        ]
    }

    tags = {
        Name = "swarm-manager"
    }
}

resource "aws_instance" "swarm-worker" {
    count           = "${var.workers_count}"
    ami             = "${var.ami}"
    instance_type   = "${var.instance_type}"
    security_groups = ["${aws_security_group.swarm-cluster.name}"]
    key_name        = "${aws_key_pair.swarm-cluster-deployer.key_name}"

    connection{
        host = "${self.public_ip}"
        user = "${var.ec2-user}"
    }
 
    provisioner "file" {
        source      = "${var.application_path}"
        destination = "/home/${var.ec2-user}/"
    }

    provisioner "file" {
        source = "~/.ssh/id_rsa"
        destination = "/home/${var.ec2-user}/.ssh/manager_key"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",
            "curl -fsSL https://get.docker.com -o get-docker.sh",
            "sh get-docker.sh",
            "sudo chmod 400 ~/.ssh/manager_key",
            "sudo scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -i ~/.ssh/manager_key ${var.ec2-user}@${aws_instance.swarm-manager.private_ip}:/home/${var.ec2-user}/token .",
            "sudo docker swarm join --token $(cat /home/${var.ec2-user}/token) ${aws_instance.swarm-manager.private_ip}:2377"
        ]
    }

    tags = {
        Name = "swarm-worker-${count.index}"
    }
}