## Terraform + AWS + Docker Swarm

Basic setup to run a Docker Swarm Cluster in AWS using Terraform

## Installing

### AWS CLI
- **Linux**

1. Install AWS CLI
```bash
sudo apt-get install awscli
```

1. Setup your AWS credentials file adding the default profile:

```bash
mkdir ~/.aws
touch ~/.aws/credentials
```

1. Add your credentials to the file, such as below:
```bash
vi ~/.aws/credentials
```

```
[default]
aws_access_key_id=XXXXXXXXX
aws_secret_access_key=XXXXXXXXXX
region=us-east-1
```

### Terraform 0.12.08

- **Linux**

1. Install unzip
```bash
sudo apt-get install unzip
```

1. Install jq
```bash
sudo apt-get install jq
```

1. Download latest version of the terraform

```bash
wget https://releases.hashicorp.com/terraform/0.12.8/terraform_0.12.8_linux_amd64.zip
```

1. Extract the downloaded file archive
```bash
unzip terraform_0.12.08_linux_amd64.zip
```

1. Move the executable into a directory searched for executables
```bash
sudo mv terraform /usr/local/bin/
```

1. Run it
```bash
terraform --version 
```
## Run

Inside project directory initialize Terrraform:


```bash
terraform init
```

Creating:

```bash
terraform apply 
```

Deleting:

```bash
terraform destroy
```
