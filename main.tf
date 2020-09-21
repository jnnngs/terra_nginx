
provider "aws" {
    #region = "eu-west-2"
    region = "${var.aws_region}"
}

resource "aws_instance" "myInstance" {
  #https://cloud-images.ubuntu.com/locator/ec2/
  #ami           = "ami-00db2b50b3b025163" #18.04 instance-store
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.nginx-sg.id}"]
  user_data     = <<-EOF
                  #!/bin/bash
                  sudo su
                  apt-get remove apt-listchanges --assume-yes --force-yes
                  apt-get -fuy --force-yes autoremove
                  apt-get --force-yes clean
                  export DEBIAN_FRONTEND=noninteractive
                  apt-get update
                  apt-get -yq upgrade
                  apt-get -yq install nginx unzip wget git-core
                  #echo "<p> My Instance! </p>" >> /var/www/html/index.html
                  #wget -O /var/www/html/index.html https://raw.githubusercontent.com/jnnngs/jnnngs.github.io/master/index.html
                  #wget -O /var/www/html/index.css https://raw.githubusercontent.com/jnnngs/jnnngs.github.io/master/index.css
                  #wget -O /var/www/html/index.js https://raw.githubusercontent.com/jnnngs/jnnngs.github.io/master/index.js
                  #wget -O /var/www/html/jnnn.gs.txt https://raw.githubusercontent.com/jnnngs/jnnngs.github.io/master/jnnn.gs.txt
                  wget -O /var/www/html/master.zip https://github.com/jnnngs/jnnngs.github.io/archive/master.zip
                  unzip -o -j /var/www/html/master.zip 'jnnngs.github.io-master/*' -d /var/www/html
                  chown -R www-data:www-data /var/www
                  EOF
}

resource "aws_security_group" "nginx-sg" {
    name = "nginx-sg"
    description = "nginx security group"
    vpc_id = "${data.aws_vpc.currentvpc.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "DNS" {
  value = aws_instance.myInstance.public_dns
}