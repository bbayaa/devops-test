#!/usr/bin/env bash

#set -ex

usage()
{
	echo "USAGE: Sets up AWS account user/role to use the AWS CLI and invokes terraform."
	echo
	echo "OPTIONS"
	echo
	echo "	-p | --profile              AWS_PROFILE               AWS-CLI profile encapsulating authenticated and authorized credentials" 
	echo "	-r | --region               AWS_REGION                AWS region from which to operate"
	echo "	-b | --bucket               S3_BACKEND_BUCKET         S3 bucket in which to store the state file"
	echo "	-a | --access-key-id        AWS_ACCESS_KEY_ID         AWS access key ID of the AWS user/role"
	echo "	-s | --secret-access-key    AWS_SECRET_ACCESS_KEY     AWS secret-access key of the user/role"
	echo "	-S | --session-token        AWS_SESSION_TOKEN         AWS session token of the user/role"
	echo "	-A | --action               TERRAFORM_ACTION          Terraform operation to invoke (e.g. 'plan', 'apply', 'destroy', etc.)"
	echo "	-v | --verbose              VERBOSE                   Whether or not to enable verbose logging"
	echo "	-h | --help                                           Displays this help message"
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
		-b | --bucket)
			S3_BACKEND_BUCKET="${2}"
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
		-a | --action)
			TERRAFORM_ACTION=${2}
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

AWS_PROFILE=$(validate_input "AWS Profile" ${AWS_PROFILE})
AWS_REGION=$(validate_input "AWS Region" ${AWS_REGION})
AWS_ACCESS_KEY_ID=$(validate_input "AWS access key ID of the AWS user/role" ${AWS_ACCESS_KEY_ID})
AWS_SECRET_ACCESS_KEY=$(validate_input "AWS secret-access key of the AWS user/role" ${AWS_SECRET_ACCESS_KEY})
AWS_SESSION_TOKEN=$(validate_input "AWS session token of the AWS user/role" ${AWS_SESSION_TOKEN})
S3_BACKEND_BUCKET=$(validate_input "S3 bucket hosting state file" ${S3_BACKEND_BUCKET})
TERRAFORM_ACTION=$(validate_input "Terraform operation to invoke" ${TERRAFORM_ACTION})

###############################################################
# Main Functionality
###############################################################
aws configure --profile ${AWS_PROFILE} set aws_access_key_id ${AWS_ACCESS_KEY_ID}
aws configure --profile ${AWS_PROFILE} set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
aws configure --profile ${AWS_PROFILE} set aws_session_token ${AWS_SESSION_TOKEN}

print_green "Successfully configured AWS credentials"

export TF_VAR_aws_profile=${AWS_PROFILE}
export TF_VAR_aws_region=${AWS_REGION}

verbose_log "Creating S3 backend configuration"
cat <<-EOF > __backend.tf
terraform {
  backend "s3" {
    bucket  = "${S3_BACKEND_BUCKET}"
    key     = "terraform.tfstate"
    profile = "${AWS_PROFILE}"
    region  = "${AWS_REGION}"
  }
}
EOF

terraform init
terraform $TERRAFORM_ACTION