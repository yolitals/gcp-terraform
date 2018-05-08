# Google cloud platform with terraform
## Prerequisites
* Install [Google SDK](https://cloud.google.com/sdk/downloads)
* Instal [Terraform](https://www.terraform.io/intro/getting-started/install.html)
* Instal [Ansible](http://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## GCP configuration

* Set up environment variables
```sh
$ export TF_VAR_billing_account=YOUR_BILLING_ACCOUNT_ID
$ export TF_ADMIN=${USER}-terraform-admin
$ export TF_CREDS=~/.config/gcloud/terraform-admin.json
```

* Create a terraform project

```sh
gcloud projects create ${TF_ADMIN} \
  --set-as-default

gcloud beta billing projects link ${TF_ADMIN} \
  --billing-account ${TF_VAR_billing_account}

```

* Create a service account

```sh
gcloud iam service-accounts create terraform \
  --display-name "Terraform admin account"

gcloud iam service-accounts keys create ${TF_CREDS} \
  --iam-account terraform@${TF_ADMIN}.iam.gserviceaccount.com

```
* Add role to account

```$xslt
gcloud projects add-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/viewer

gcloud projects add-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/storage.admin
```
* Add services permisions
```$xslt
gcloud sersvices enable cloudresourcemanager.googleapis.com
gcloud sersvices enable cloudbilling.googleapis.com
gcloud sersvices enable iam.googleapis.com
gcloud sersvices enable compute.googleapis.com
```

* Create a bucket to terraform state files and enable versioning

```$xslt
gsutil mb -p ${TF_ADMIN} gs://${TF_ADMIN}
gsutil versioning set on gs://${TF_ADMIN}


```

* Configure your environment for the Google Cloud Terraform provider
```
export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
export GOOGLE_PROJECT=${TF_ADMIN}
```

## Execute terraform

* Initialize the backend

```
terraform init
```

* Preview the Terraform changes

```$xslt
terraform plan -var-file=dev.tfvars
```

* Apply the Terraform changes

```$xslt
terraform apply -var-file=dev.tfvars
```

If you want destroy the resources created by Terraform

```$xslt
terraform destroy -var-file=dev.tfvars
```