# RGS Workshop Infrastruction Terraform

**Step 1:** Clone the repository:
```bash
git clone https://github.com/zackbradys/rancher-workshop.git
```

**Step 2:** Update the variables in `variables.tf`:
```bash
# Add AWS Region, AWS Access Key, AWS Secret Key, and AWS SSH Key Name

variable "region" {
  default     = ""
  description = "(Required) The AWS Region to use for the instance(s)."
}

variable "access_key" {
  default = ""
  description = "(Required) The AWS Access Key to use for the instance(s)."
}

variable "secret_key" {
  default = ""
  description = "(Required) The AWS Secret Key to use for the instance(s)."
}

variable "key_pair_name" {
  default     = ""
  description = "(Required) The AWS Key Pair name to use for the instance(s)."
}

variable "domain" {
  default     = ""
  description = "(Required) The AWS Route53 Domain to use for the instance(s)."
}

variable "number_of_students" {
  default     = 30
  description = "(Required) The number of students to use for the instance(s)."
}
```

**Step 3:** Run the Terraform commands:
```bash
# cd terraform/aws-ec2-rancher-tf

terraform init

terraform plan

terraform apply --auto-approve

terraform output
```