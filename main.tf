data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

#---------------------------------------------------------------------
resource "aws_instance" "web" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
echo "<h2>Паша, гля че умею!</h2><br>

</head>
  <body>
    <p>
      <a href="https://art-lunch.ru/recipe/cheesecake_new_york_foto/">This link</a> shows you how sweet we gonna spend one day of our life =)
    </p>
    </h5><br>
//Build by Terraform!
  </body>"  >  /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF

# <<EOF
# #!/bin/bash
# yum -y update
# yum -y install httpd
# myip = `curl http://169.254.169.254/latest/meta-data/local-ipv4`
# echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!"  >  /var/www/html/index.html
# sudo service httpd start
# chkconfig httpd on
# EOF

  tags = {
    Name  = "PROD WebServer - ${terraform.workspace}"
    Owner = "Nastya"
  }
}

#---------------------------------------------------------------------
resource "aws_security_group" "web" {
  name_prefix = "WebServer SG Prod"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Web Server SecurityGroup"
    Owner = "Nastya"
  }
}

#---------------------------------------------------------------------
resource "aws_eip" "web" {
  instance = aws_instance.web.id
  tags = {
    Name  = "PROD WebServer IP"
    Owner = "Nastya"
  }
}

#---------------------------------------------------------------------
output "web_public_ip" {
  value       = aws_eip.web.public_ip
}
