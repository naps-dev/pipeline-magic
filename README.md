# Pipeline Magic for `naps-dev`

Infrastructure as Code (IaC) and GitHub Actions for the projects in `naps-dev`.

## IaC

This project uses Terraform to provision an EC2 instance and supporting infrastructure that enables self-hosted GitHub runners to be use by projectrs wthin the `naps-dev` group.

Please note: these Terraform projects assume they will be run against a specific AWS account.

<details>
<summary>Pipeline State</summary>

The [Pipeline State](pl-state/) Terraform project provisions resources in AWS for storing and managing the Terraform State for the other projects.

Resources provisioned:
* aws_s3_bucket `pipeline-magic-state`
* aws_dynamodb_table `pipeline-magic-locks`
    * String attribute `LockID`

Outputs:
* s3_bucket_arn `pipeline-magic-state` S3 bucket ARN
* dynamodb_table_name `pipeline-magic-locks` DynamoDB table name

</details>

<details>
<summary>Pipeline ECR</summary>

The [Pipeline ECR](pl-ecr/) Terraform project provisions one or more Elastic Container Registries in AWS.

Noted variables:
* `image_names` list(string) of images

Noted resources provisioned:
* aws_ecr_repository for each specified image
* aws_ecr_lifecycle_policy for each specified image

</details>

<details>
<summary>Pipeline Runner</summary>

The [Pipeline Runner](pl-runner/) Terraform project provisions a VPC, EC2 instance and associated underlying support resources. 

Noted variables:
* 

Noted resources provisioned:
* 

Outputs:
* 

</details>

<details>
<summary>Quick Start</summary>

```bash
cd pl-state
terraform init
terraform apply

cd ../pl-ec2
vi main.tf
# Verify terraform.backend{bucket, dynamidb_table} match output from pl-state project
terraform init
terraform apply

cd ../pl-runner
vi main.tf
# Verify terraform.backend{bucket, dynamidb_table} match output from pl-state project
terraform init
terraform apply

```

Follow additional configuration steps [here](https://github.com/organizations/naps-dev/settings/actions/runners/new) and [here](https://docs.github.com/en/actions/hosting-your-own-runners/configuring-the-self-hosted-runner-application-as-a-service) to join the runner to GitHub and configure it to run as a service.

</details>

## GitHub Actions

This project contains reusable GitHub actions intended to be employed by projects within the `naps-dev` group.

<details>
<summary>s3-fetch</summary>

Retreve objects from S3.

</details>

<details>
<summary>s3-publish</summary>

Publish objects to S3.

</details>

<details>
<summary>registry-login</summary>

Zarf `registry login` so that we can pull images.

</details>

<details>
<summary>package-create</summary>

Zarf `package create` command to build a Zartifact.

</details>

<details>
<summary>image-create</summary>

Create an image so that it can be pushed to a registry.

</details>

<details>
<summary>ecr-push</summary>

Tag and push an image to ECR.

</details>

<details>
<summary>vm-convert</summary>

Convert a VM from OVA to QCOW2 with virt-v2v.

</details>

<details>
<summary>vm-customize</summary>

Apply virt-customization to to a QCOW2-formatted VM.

</details>
