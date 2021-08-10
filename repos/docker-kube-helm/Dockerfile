FROM ubuntu:18.04
LABEL maintainer="Belal Bayaa belal.db@gmail.com>"

ENV HELM_VERSION="v3.2.4" \
    KUBECTL_VERSION="v1.14.0" \
    AWS_PROFILE="" \
    AWS_REGION="" \
    AWS_ACCESS_KEY_ID="" \
    AWS_SECRET_ACCESS_KEY="" \
    AWS_SESSION_TOKEN="" \
    CLUSTER_NAME="heal-eks" \
    VAULT_SECRETS_PATH="heal-app" \
    VAULT_NAMESPACE="heal-app" \
    VAULT_SERVICE_ACCOUNT_NAME="heal-vault" \
    REDIS_URL="" \
    MONGODB_URI=""

RUN apt-get update \
    && apt-get install curl unzip wget git -y \
    && rm -rf /var/lib/apt/lists/* \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip -o awscliv2.zip \
    && ./aws/install \
    && curl -LO "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && rm -rf helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && git clone https://github.com/bbayaa/devops-test.git /opt/devops-test

WORKDIR /opt/devops-test/repos/kube-resources

ENTRYPOINT ["/bin/sh", "-c", "../bash-scripts/deploy_heal.sh"]
