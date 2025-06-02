#!/bin/bash
snap install amazon-ssm-agent --classic

snap start amazon-ssm-agent

jenkins_ip="$1"

apt update -y

apt install -y nginx

nginx_ip=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

tee /etc/nginx/conf.d/jenkins.conf > /dev/null <<EOF
server {
  listen 80;
  server_name $nginx_ip;

  location / {
    proxy_pass http://${jenkins_ip}:8080/;
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;

    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
  }
}
EOF

chmod 0644 /etc/nginx/conf.d/jenkins.conf
chown root:root /etc/nginx/conf.d/jenkins.conf

systemctl restart nginx
systemctl enable nginx

