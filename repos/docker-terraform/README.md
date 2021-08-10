# Docker Terraform

Ideally:
* This would be its own repository, and it would be versioned/tagged with every release. In this way, application-development teams can leverage it and reference newer versions when they are ready. An example of a change is a version upgrade of Terraform that could result in backwards-incompatibility.
* A backend Terraform configuration would send the state file to a versioned S3 bucket (rather than through a "terraform.tfstate" file)
* The terraform modules would be in their own repository and they would be versioned/tagged, then sourced within this repository through a git link

This image exists so that the user does not have to install Terraform locally on their workstation. To run this, the following environment variables are needed:

| Environment Variable | Description |
| ----------------------|:-------------:|
| AWS_PROFILE | What you want to name the AWS profile which embeds the credentials |
| AWS_REGION | AWS region in which to provision the infrastructure |
| AWS_ACCESS_KEY_ID | AWS access-key ID for Terraform service account |
| AWS_SECRET_ACCESS_KEY | AWS secret-access key for Terraform service account |
| AWS_SESSION_TOKEN | AWS session token for Terraform service account |
| S3_BACKEND_BUCKET | S3 bucket in which to store the Terraform state file |

**Table I** _Environment variables required to run this Docker image_


Instructions to run this image:

```
# Provision the infrastructure
docker run -it --env-file <env_file> bbayaa/heal-app-terraform:0.0.1
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
S3_BACKEND_BUCKET=<value>
```

Once the container runs, it will prompt you for which terraform operation to invoke. </br>
For example, to deploy the infrastructure, you would enter `apply`
To destroy, enter: `destroy`
To preview, enter: `plan`
The state file should appear in the S3 bucket configured.