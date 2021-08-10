#!/usr/bin/env bash

#set -ex

usage()
{
	echo "USAGE: Deploys all components of the Heal DevOps test app:"
	echo "       1. Configures the KUBECONFIG to point to the EKS cluster"
	echo "       2. Deploys the cluster resources (namespaces, deployments, service accounts, services)"
	echo "       3. Installs Hashicorp Vault and configures secrets"
	echo "       4. Patches worker app deployment with sidecar injector agent"
	echo
	echo "OPTIONS"
	echo
	echo "	-p | --profile              AWS_PROFILE                   AWS-CLI profile encapsulating authenticated and authorized credentials" 
	echo "	-r | --region               AWS_REGION                    AWS region from which to operate"
	echo "	-a | --access-key-id        AWS_ACCESS_KEY_ID             AWS access key ID of the AWS user/role"
	echo "	-s | --secret-access-key    AWS_SECRET_ACCESS_KEY         AWS secret-access key of the user/role"
	echo "	-S | --session-token        AWS_SESSION_TOKEN             AWS session token of the user/role"
	echo "	-n | --cluster-name         CLUSTER_NAME                  Name of the EKS cluster"
	echo ""
	echo "	-P | --secrets-path         VAULT_SECRETS_PATH            Path of the secrets in Vault"
	echo "	-N | --vault-namespace      VAULT_NAMESPACE               Namespace in which to deploy Hashicorp Vault"
	echo "	-a | --vault-sa             VAULT_SERVICE_ACCOUNT_NAME    Name of the Vault service account to tie to the Kubernetes deployment"
	echo "	-R | --redis-url            REDIS_URL                     Secret value for the Redis instance's URL"
	echo "	-M | --mongodb-uri          MONGODB_URI                   Secret value for the MongoDB instance's URI"
	echo ""
	echo "	-v | --verbose              VERBOSE                       Whether or not to enable verbose logging"
	echo "	-h | --help                                               Displays this help message"
	echo
}

###############################################################
# Get the inputs
###############################################################
while [[ $# -gt 0 ]]; do
	case "${1}" in
		-p | --profile)
			AWS_PROFILE="${2}"
			shift
			shift
			;;
		-r | --region)
			AWS_REGION="${2}"
			shift
			shift
			;;
		-a | --access-key-id)
			AWS_ACCESS_KEY_ID=${2}
			shift
			shift
			;;
		-s | --secret-access-key)
			AWS_SECRET_ACCESS_KEY=${2}
			shift
			shift
			;;
		-S | --session-token)
			AWS_SESSION_TOKEN=${2}
			shift
			shift
			;;
		-P | --secrets-path)
			VAULT_SECRETS_PATH="${2}"
			shift
			shift
			;;
		-N | --vault-namespace)
			VAULT_NAMESPACE="${2}"
			shift
			shift
			;;
		-a | --vault-sa)
			VAULT_SERVICE_ACCOUNT_NAME="${2}"
			shift
			shift
			;;
		-R | --redis-url)
			REDIS_URL="${2}"
			shift
			shift
			;;
		-M | --mongodb-uri)
			MONGODB_URI="${2}"
			shift
			shift
			;;
		-v | --verbose)
				VERBOSE=1
				shift
				;;
		-h | --help)
				usage
				exit
				;;
		*)
			echo
			echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
			echo "Unknown parameter '${1}'. Please refer to usage details."
			echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
			echo
			usage
			exit 1
			;;
	esac
done

###############################################################
# Validate the inputs
###############################################################
. $(dirname `which ${0}`)/_lib.sh
#----------------------#
#    Vault Script
#----------------------#
#export VAULT_SECRETS_PATH=heal-app
#export VAULT_NAMESPACE=heal-app
#export VAULT_SERVICE_ACCOUNT_NAME=heal-vault
#export REDIS_URL=redis://redis-svc:6379
#export MONGODB_URI=mongodb://mongodb0.example.com:27017
#export AWS_PROFILE=belal
#export AWS_REGION=us-east-1
#export CLUSTER_NAME=heal-eks

AWS_PROFILE=$(validate_input "AWS Profile" ${AWS_PROFILE})
AWS_REGION=$(validate_input "AWS Region" ${AWS_REGION})
AWS_ACCESS_KEY_ID=$(validate_input "AWS access key ID of the AWS user/role" ${AWS_ACCESS_KEY_ID})
AWS_SECRET_ACCESS_KEY=$(validate_input "AWS secret-access key of the AWS user/role" ${AWS_SECRET_ACCESS_KEY})
AWS_SESSION_TOKEN=$(validate_input "AWS session token of the AWS user/role" ${AWS_SESSION_TOKEN})

CLUSTER_NAME=$(validate_input "Name of the EKS cluster" ${CLUSTER_NAME})
VAULT_SECRETS_PATH=$(validate_input "Path of the secrets in Vault" ${VAULT_SECRETS_PATH})
VAULT_NAMESPACE=$(validate_input "Namespace in which to deploy Hashicorp Vault" ${VAULT_NAMESPACE})
VAULT_SERVICE_ACCOUNT_NAME=$(validate_input "Name of the Vault service account" ${VAULT_SERVICE_ACCOUNT_NAME})
REDIS_URL=$(validate_input "Secret value for the Redis instance's URL" ${REDIS_URL})
MONGODB_URI=$(validate_input "Secret value for the MongoDB instance's URI" ${MONGODB_URI})

###############################################################
# Main Functionality
###############################################################
aws configure --profile ${AWS_PROFILE} set aws_access_key_id ${AWS_ACCESS_KEY_ID}
aws configure --profile ${AWS_PROFILE} set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
aws configure --profile ${AWS_PROFILE} set aws_session_token ${AWS_SESSION_TOKEN}

aws eks update-kubeconfig --profile ${AWS_PROFILE} --region ${AWS_REGION} --name ${CLUSTER_NAME}

verbose_log "Provisioning Kubernetes cluster resources"
kubectl apply -f namespaces.yaml && kubectl apply -f .

verbose_log "Installing Hashicorp Vault"
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm install vault hashicorp/vault --set "server.dev.enabled=true" -n ${VAULT_NAMESPACE}

verbose_log "Waiting for deployment to settle"
sleep 4s

verbose_log "Configuring Hashicorp Vault"
kubectl exec vault-0 -n ${VAULT_NAMESPACE} -- vault secrets enable -path=${VAULT_SECRETS_PATH} kv-v2
kubectl exec vault-0 -n ${VAULT_NAMESPACE} -- vault kv put ${VAULT_SECRETS_PATH}/config REDIS_URL="${REDIS_URL}" MONGODB_URI="${MONGODB_URI}"
kubectl exec vault-0 -n ${VAULT_NAMESPACE} -- vault auth enable kubernetes
kubectl exec vault-0 -n ${VAULT_NAMESPACE} -- /bin/sh -c 'vault write auth/kubernetes/config \
    token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
    kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'
kubectl exec vault-0 -n ${VAULT_NAMESPACE} --tty=false -- /bin/sh -ec "vault policy write ${VAULT_SECRETS_PATH} - <<EOF
path \"${VAULT_SECRETS_PATH}/data/config\" {
  capabilities = [\"read\"]
}
EOF"
kubectl exec vault-0 -n ${VAULT_NAMESPACE} -- vault write auth/kubernetes/role/${VAULT_SECRETS_PATH} \
    bound_service_account_names=${VAULT_SERVICE_ACCOUNT_NAME} \
    bound_service_account_namespaces=${VAULT_NAMESPACE} \
    policies=${VAULT_SECRETS_PATH} \
    ttl=24h

cat <<-EOF > vault_patch.yaml
spec:
  template:
    metadata:
      annotations:
        vault.hashicorp.com/agent-inject: 'true'
        vault.hashicorp.com/role: '${VAULT_SECRETS_PATH}'
        vault.hashicorp.com/agent-inject-secret-config.txt: '${VAULT_SECRETS_PATH}/config'
        vault.hashicorp.com/agent-inject-template-config.txt: |
          {{- with secret "${VAULT_SECRETS_PATH}/config" -}}
            export REDIS_URL={{ .Data.data.REDIS_URL }}
            export MONGODB_URI={{ .Data.data.MONGODB_URI }}
          {{- end -}}
EOF

verbose_log "Injecting sidecar"
kubectl patch deployment heal-worker -n ${VAULT_NAMESPACE} --patch "$(cat vault_patch.yaml)"
rm -rf vault_patch.yaml