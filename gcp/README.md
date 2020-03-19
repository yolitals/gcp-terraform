# Google cloud platform with terraform
## Prerequisites
* Install [Google SDK](https://cloud.google.com/sdk/downloads)
* Instal [Terraform](https://www.terraform.io/intro/getting-started/install.html)
* Instal [Ansible](http://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## GCP configuration
* Login into Google Cloud Platform via gcloud
```sh
$ gcloud auth login 

#That command will generate an URL, open it and continue with the authentication instructions. 
```
* Set up environment variables
```sh
$ export TF_VAR_billing_account=YOUR_BILLING_ACCOUNT_ID
$ export TF_ADMIN_PROJECT="${USER}-terraform-admin" # Name of the project to create
$ export TF_CREDS = /path/of/the/gcp/credentials/${TF_ADMIN_PROJECT}.json #Where you want save your credentials
# ${USER} your user or another prefix, the ID of the project should be unique on all gcp domain. 
```

* Create a terraform project

  This project will contain all necesary resources to can manage the rest of the infrastructure via Terraform.

```sh
$ gcloud projects create ${TF_ADMIN_PROJECT} --set-as-default

$ gcgcloud beta billing projects link ${TF_ADMIN_PROJECT} \
  --billing-account ${TF_VAR_billing_account}

```

* Create a service account

```sh
gcloud iam service-accounts create terraform \
  --display-name "Terraform admin account"

gcloud iam service-accounts keys create ${TF_CREDS} \
  --iam-account terraform@${TF_ADMIN_PROJECT}.iam.gserviceaccount.com

```
* Add role to account

```sh
$ gcloud projects add-iam-policy-binding ${TF_ADMIN_PROJECT} \
  --member serviceAccount:terraform@${TF_ADMIN_PROJECT}.iam.gserviceaccount.com \
  --role roles/compute.admin

$ gcloud projects add-iam-policy-binding ${TF_ADMIN_PROJECT} \
  --member serviceAccount:terraform@${TF_ADMIN_PROJECT}.iam.gserviceaccount.com \
  --role roles/storage.admin
```
* Add services permisions
```sh

$ gcloud services enable cloudbilling.googleapis.com
$ gcloud services enable compute.googleapis.com
```

* Create a bucket to terraform state files and enable versioning

```sh
$ gsutil mb -p ${TF_ADMIN_PROJECT} gs://${TF_ADMIN_PROJECT}
```
* Create ssh key

  Create ssh key to can connect via ansible to complete the provisioning. 

```sh
$ ssh-keygen -f ~/.ssh/google_compute_engine
# Without passphrase
# You can use a diferent output file but remember change it in medatada >> sshKeys into main.tf


```
* Configure your environment for the Google Cloud Terraform provider
```
export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
export GOOGLE_PROJECT=${TF_ADMIN_PROJECT}
```

## Execute terraform

* Initialize the backend

```
$ terraform init
```

* Preview the Terraform changes

```sh
$ terraform plan -var-file=dev.tfvars
```

* Apply the Terraform changes

```sh
$ terraform apply -var-file=dev.tfvars
```

If you want destroy the resources created by Terraform

```
$ terraform destroy -var-file=dev.tfvars
```