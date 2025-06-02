#!/bin/bash
apt update -y

apt install -y unzip jq apt-transport-https ca-certificates curl gnupg

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip

./aws/install

rm awscliv2.zip
rm -rf aws/

snap install amazon-ssm-agent --classic

snap start amazon-ssm-agent


mkdir -p /etc/apt/keyrings
chmod 0755 /etc/apt/keyrings

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key -o /etc/apt/keyrings/jenkins-keyring.asc
chmod 0644 /etc/apt/keyrings/jenkins-keyring.asc

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

apt update -y

apt install -y openjdk-21-jre fontconfig

apt install -y jenkins

systemctl start jenkins
systemctl enable jenkins

JENKINS_URL="http://localhost:8080"

until curl -s -o /dev/null -w "%{http_code}" "$JENKINS_URL/login" | grep -q "200"; do
  sleep 5
done

while true; do
    curl -fsSL -o jenkins-cli.jar "$JENKINS_URL/jnlpJars/jenkins-cli.jar"
    
    if [ -s jenkins-cli.jar ]; then
        break
    fi
    sleep 5
done

USER="node_generator"
PASSWORD="node_generator"

ADMIN_USER="admin"
ADMIN_PASS=$(cat /var/lib/jenkins/secrets/initialAdminPassword)
echo "jenkins.model.Jenkins.instance.securityRealm.createAccount(\"$USER\", \"$PASSWORD\")" | java -jar jenkins-cli.jar -s "$JENKINS_URL" -auth "$ADMIN_USER:$ADMIN_PASS" groovy =

curl -O https://raw.githubusercontent.com/danielfarag/jenkins-aws-private-master-ssm-slaves/main/dist/cron.sh
curl -O https://raw.githubusercontent.com/danielfarag/jenkins-aws-private-master-ssm-slaves/main/dist/delete-node.groovy

chmod +x /cron.sh


(crontab -l 2>/dev/null; echo "* * * * * /cron.sh") | crontab -
