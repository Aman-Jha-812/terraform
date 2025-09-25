provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "allow_ports" {
  name        = "allow-flask-express"
  description = "Allow SSH and app ports"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flask Backend"
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Express Frontend"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [aws_security_group.allow_ports.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get upgrade -y

              # Install Python3, pip
              sudo apt-get install -y python3 python3-pip git

              # Install Node.js 18.x and npm
              curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
              sudo apt-get install -y nodejs

              # Install pm2 globally for Node app management
              sudo npm install -g pm2

              # Clone project repo (replace with your actual repo URL)
              # Assuming project code is pushed to GitHub
              git clone https://github.com/username/project-root.git /home/ubuntu/project-root

              # Setup Flask backend
              cd /home/ubuntu/project-root/flask-backend
              pip3 install -r requirements.txt
              # Run Flask app in background
              nohup python3 app.py &

              # Setup Express frontend
              cd /home/ubuntu/project-root/express-frontend
              npm install
              pm2 start server.js --name express-app

              EOF

  tags = {
    Name = "FlaskExpressServer"
  }
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}
