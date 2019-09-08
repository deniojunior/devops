 output "manager-ip" {
  value = "${aws_instance.swarm-manager.public_ip}"
}