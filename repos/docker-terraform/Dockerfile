FROM ubuntu:18.04
LABEL maintainer="Belal Bayaa <belal.db@gmail.com>"

ENV TERRAFORM_VERSION="1.0.3" \
    S3_BACKEND_BUCKET="" \
    AWS_PROFILE="" \
    AWS_REGION="" \
    AWS_ACCESS_KEY_ID="" \
    AWS_SECRET_ACCESS_KEY="" \
    AWS_SESSION_TOKEN=""

RUN apt-get update -y \
    && apt-get install curl git wget unzip jq git -y \
    && curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/ \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip -o awscliv2.zip \
    && ./aws/install \
    && git clone https://github.com/bbayaa/devops-test.git /opt/devops-test

WORKDIR /opt/devops-test/repos/terraform

ENTRYPOINT ["/bin/sh", "-c", "../bash-scripts/invoke_tf.sh"]
