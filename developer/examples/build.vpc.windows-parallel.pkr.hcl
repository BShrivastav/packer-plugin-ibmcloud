// packer {
//   required_plugins {
//     ibmcloud = {
//       version = ">=v3.0.0"
//       source = "github.com/IBM/ibmcloud"
//     }
//   }
// }

variable "ANSIBLE_INVENTORY_FILE" {
  type    = string
  default = "provisioner/hosts"
}


variable "IBM_API_KEY" {
  type = string
}

variable "SUBNET_ID" {
  type = string
}

variable "REGION" {
  type = string
}

variable "RESOURCE_GROUP_ID" {
  type = string
}

variable "SECURITY_GROUP_ID" {
  type = string
}
// variable "VPC_URL" {
//   type = string
// }
// variable "IAM_URL" {
//   type = string
// }


locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "ibmcloud-vpc" "windows" {
  api_key           = var.IBM_API_KEY
  region            = var.REGION
  subnet_id         = var.SUBNET_ID
  resource_group_id = var.RESOURCE_GROUP_ID
  security_group_id = var.SECURITY_GROUP_ID

  vsi_base_image_name = "ibm-windows-server-2019-full-standard-amd64-8"
  vsi_profile        = "bx2-2x8"
  vsi_interface      = "public"
  vsi_user_data_file = "scripts/winrm_setup.ps1"

  image_name = "packer-${local.timestamp}-1"

  communicator   = "winrm"
  winrm_username = "Administrator"
  winrm_port     = 5986
  winrm_timeout  = "15m"
  winrm_insecure = true
  winrm_use_ssl  = true

  timeout = "60m"
}

source "ibmcloud-vpc" "windows-other" {
  api_key           = var.IBM_API_KEY
  region            = var.REGION
  subnet_id         = var.SUBNET_ID
  resource_group_id = var.RESOURCE_GROUP_ID
  security_group_id = var.SECURITY_GROUP_ID

  vsi_base_image_name = "ibm-windows-server-2019-full-standard-amd64-8"
  vsi_profile        = "bx2-2x8"
  vsi_interface      = "public"
  vsi_user_data_file = "scripts/winrm_setup.ps1"

  image_name = "packer-${local.timestamp}-1"

  communicator   = "winrm"
  winrm_username = "Administrator"
  winrm_port     = 5986
  winrm_timeout  = "15m"
  winrm_insecure = true
  winrm_use_ssl  = true

  timeout = "60m"
}

build {
  sources = [
    "source.ibmcloud-vpc.windows",
    "source.ibmcloud-vpc.windows-other"
  ]

  provisioner "shell" {
    execute_command = "{{.Vars}} bash '{{.Path}}'"
    inline = [
      "echo 'Hello from IBM Cloud Packer Plugin - VPC Infrastructure'",
      "echo 'Hello from IBM Cloud Packer Plugin - VPC Infrastructure' >> /hello.txt"
    ]
  }
}
