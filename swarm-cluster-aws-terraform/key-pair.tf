resource "aws_key_pair" "swarm-cluster-deployer" {
  key_name = "swarm-cluster-deployer"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}
