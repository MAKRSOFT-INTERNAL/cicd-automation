#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl jq unzip docker.io awscli

systemctl enable docker
systemctl start docker

REGION="__AWS_REGION__"
REGISTRATION_PARAMETER="__REGISTRATION_PARAMETER__"
ORGANIZATION="__GITHUB_ORGANIZATION__"
INSTANCE_ID=$(ec2metadata --instance-id)

mkdir -p /opt/actions-runner
cd /opt/actions-runner

RUNNER_TOKEN=$(aws ssm get-parameter \
  --name "$REGISTRATION_PARAMETER" \
  --with-decryption \
  --region "$REGION" \
  --query 'Parameter.Value' \
  --output text)

RUNNER_VERSION="2.330.0"
curl --fail --location \
  "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" \
  --output actions-runner.tar.gz
tar xzf actions-runner.tar.gz

./config.sh \
  --unattended \
  --url "https://github.com/$ORGANIZATION" \
  --token "$RUNNER_TOKEN" \
  --name "ec2-$INSTANCE_ID" \
  --labels "docker-agent,linux,x64,ephemeral-ec2" \
  --work "_work" \
  --ephemeral \
  --disableupdate \
  --replace

./run.sh
