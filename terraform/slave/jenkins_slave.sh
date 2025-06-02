#!/bin/bash

while ! ping -c 1 8.8.8.8 &> /dev/null; do sleep 5; done

apt update -y

apt install -y unzip jq apt-transport-https ca-certificates curl gnupg openjdk-17-jre-headless

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip

./aws/install

rm awscliv2.zip
rm -rf aws/

snap install amazon-ssm-agent --classic

snap start amazon-ssm-agent

mkdir -p /home/ubuntu/jenkins


INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')
GROUP=$(aws ec2 describe-tags --region "$REGION" --filters "Name=resource-id,Values=$INSTANCE_ID" --output json | jq -r '.Tags[] | select(.Key == "Group").Value')

master_ip=$(aws ec2 describe-instances   --filters "Name=tag:Group,Values=$GROUP" "Name=tag:Jenkins,Values=Master" "Name=instance-state-name,Values=running"  --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
USER="node_generator"
PASSWORD="node_generator"
NODE_NAME="my-jnlp-on-master-agent-$(date +%s)"


until curl -s -o /dev/null -w "%{http_code}" "http://$master_ip:8080/login" | grep -q "200"; do
  sleep 5
done

curl -o jenkins-cli.jar http://$master_ip:8080/jnlpJars/jenkins-cli.jar

curl -O https://raw.githubusercontent.com/danielfarag/jenkins-aws-private-master-ssm-slaves/main/dist/node.xml

sed -i "s/node-name/$NODE_NAME/g" /node.xml

java -jar /jenkins-cli.jar -s "http://$master_ip:8080" -auth "$USER:$PASSWORD" create-node < /node.xml

AGENT_SECRET=$(java -jar /jenkins-cli.jar -s "http://$master_ip:8080" -auth "$USER:$PASSWORD" groovy = <<< "println jenkins.model.Jenkins.instance.nodesObject.getNode('${NODE_NAME}')?.computer?.jnlpMac" )

curl -o agent.jar http://$master_ip:8080/jnlpJars/agent.jar

java -jar /agent.jar -url http://$master_ip:8080/ -secret $AGENT_SECRET -name "$NODE_NAME" -webSocket  > agent.log 2>&1 &