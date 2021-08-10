# Docker Kube/Helm

Ideally:
* This would be its own repository, and it would be versioned/tagged with every release. In this way, application-development teams can leverage it and reference newer versions when they are ready. An example of a change is a version upgrade of Terraform that could result in backwards-incompatibility.
* Vault would be deployed in a separate cluster altogether and would be referenced from multiple apps

This image exists so that the user does not have to install dependencies like `aws`, `kubectl`, and `helm` locally on their workstation. To run this, the following environment variables are needed:

| Environment Variable | Description |
| ----------------------|:-------------:|
| AWS_PROFILE | What you want to name the AWS profile which embeds the credentials |
| AWS_REGION | AWS region in which to provision the infrastructure |
| AWS_ACCESS_KEY_ID | AWS access-key ID for Terraform service account |
| AWS_SECRET_ACCESS_KEY | AWS secret-access key for Terraform service account |
| AWS_SESSION_TOKEN | AWS session token for Terraform service account |
| CLUSTER_NAME | Name of the EKS cluster in AWS |
| VAULT_SECRETS_PATH | Path of the secrets in Vault |
| VAULT_NAMESPACE | Namespace in which to deploy Hashicorp Vault |
| VAULT_SERVICE_ACCOUNT_NAME | Name of the Vault service account |
| REDIS_URL | Secret value for the Redis instance's URL |
| MONGODB_URI | Secret value for the MongoDB instance's URI |

**Table I** _Environment variables required to run this Docker image_


Instructions to run this image:

```
# Provision the infrastructure
docker run -it --env-file <env_file> bbayaa/heal-app-terraform:0.0.1
docker run -it --env-file <env_file> bbayaa/heal-k8s-vault-config:0.0.1
```

where

* `<env_file>` is a file in which the environment-variable values in Table I are set </br>

The <env_file> file should look as-follows (without quotes):
```
AWS_PROFILE=<value>
AWS_REGION=<value>
AWS_ACCESS_KEY_ID=<value>
AWS_SECRET_ACCESS_KEY=<value>
AWS_SESSION_TOKEN=<value>
REDIS_URL=<value>
MONGODB_URI=<value>
```

This is highly-dependent on the infrastructure, and default values have already been set in the Dockerfile.</br>
The `REDIS_URL` parameter should match that of the service provisioned in the Kubernetes cluster, and the `MONGODB_URI` parameter just takes in a sample value.